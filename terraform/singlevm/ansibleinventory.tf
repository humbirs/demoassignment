# generate inventory file for Ansible
resource "local_file" "hosts_inventory" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      webappserver = azurerm_network_interface.main.*.private_ip_address
    }
  )
  filename = "../../ansible/inventory/hosts_webapp"

  depends_on = [
    azurerm_virtual_machine.appvm
  ]
}
