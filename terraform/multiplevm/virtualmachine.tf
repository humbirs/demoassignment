
resource "azurerm_virtual_machine" "appvm" {

  #CORE INFRASTRUCTURE DETAILS
  count               = length(var.name_count)
  name                = element(var.name_count, count.index)
  location            = var.location
  resource_group_name = var.resource_group_name
  #network_interface_ids = [azurerm_network_interface.main.id]
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
  vm_size               = var.environment == "production" ? var.machine_type_PROD : var.machine_type_DEV

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true
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
    name              = "${var.prefix}-osdisk-${element(var.name_count, count.index)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "128"
  }


  # PROFILE OF THE VM - USER / PASSWORD
  os_profile {
    computer_name  = element(var.name_count, count.index)
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # TAGS with KEY VALUE PAIR
  tags = var.tags
}