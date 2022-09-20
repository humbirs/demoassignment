
data "template_file" "nginx_config" {
  template = "${file("${path.module}/files/nginx.conf")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content       = "packages: ['netcat']"
  }

}

resource "azurerm_virtual_machine" "appvm" {

  #CORE INFRASTRUCTURE DETAILS
  name                  = "${var.prefix}-${var.computername}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.environment == "production" ? var.machine_type_PROD : var.machine_type_DEV
  
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  # Which OS THE VM WILL HAVE
  #  storage_image_reference {
  #    publisher = var.publisher
  #    offer     = var.offer
  #    sku       = var.sku
  #    version   = var.version
  #  }

  storage_image_reference {
    id = data.azurerm_image.search.id
  }

  # MAIN STORAGE DISK 
  storage_os_disk {
    name              = "${var.prefix}-${var.computername}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "128"
  }


  # PROFILE OF THE VM - USER / PASSWORD
  os_profile {
    computer_name  = var.computername
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = data.template_cloudinit_config.config.rendered

  }
  
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      #key_data = file("~/.ssh/id_rsa.pub")
      key_data = var.publickey
    }
  }
  connection {
      type        = "ssh"
      host        = azurerm_network_interface.main.private_ip_address
      user        = var.admin_username
      private_key = file("~/.ssh/id_rsa")
    }
 
  # This is to ensure SSH comes up before we run the exec.

   provisioner "file" {
    content      = "${tls_self_signed_cert.ca.cert_pem}"
    destination = "/tmp/cacert.crt"
  }

   provisioner "file" {
    content      = "${tls_locally_signed_cert.default.cert_pem}"
    destination = "/tmp/server.crt"
  }
   provisioner "file" {
    content      = "${tls_private_key.default.private_key_pem}"
    destination = "/tmp/server.key"
  }
    provisioner "file" {
    content = "${data.template_file.nginx_config.rendered}"
    destination = "/tmp/nginx.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y nginx && sudo systemctl start nginx && sudo systemctl enable nginx",
      "sudo firewall-offline-cmd --add-port=80/tcp ",
      "sudo firewall-offline-cmd --add-port=443/tcp ",
      "sudo /bin/systemctl restart firewalld",
      "sudo mkdir -p /etc/nginx/certificate",
      "sudo mv /tmp/cacert.crt /etc/nginx/certificate/cacert.crt -f && sudo mv -f /tmp/server.crt /etc/nginx/certificate/server.crt" ,
      "sudo mv /tmp/server.key /etc/nginx/certificate/server.key -f && sudo mv -f /tmp/nginx.conf /etc/nginx/nginx.conf ",
      "sudo systemctl restart nginx",
      "echo '<h1><center>My first website using terraform provisioner</center></h1>' > index.html",
      "echo '<h1><center>Humbir demo server</center></h1>' >> index.html",
      "sudo mv -f index.html /usr/share/nginx/html/"
    ]
    
  }
  

  # TAGS with KEY VALUE PAIR
  tags = var.tags
  depends_on = [
      tls_private_key.default,tls_locally_signed_cert.default
  ]
}


