
##Create public ip
#resource "azurerm_public_ip" "main" {
#  count               = length(var.name_count)
#  name                = element(var.name_count, count.index)
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  allocation_method   = "Dynamic"
#  domain_name_label   = "${var.prefix}-url-${element(var.name_count, count.index)}"
#}

# Create a Network Security Group with some rules
resource "azurerm_network_security_group" "main" {
  count               = length(var.name_count)
  name                = "${element(var.name_count, count.index)}_NSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_network_interface" "main" {
  count               = length(var.name_count)
  name                = "${var.prefix}-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    #    count                         = length(var.name_count)
    name                          = "ipconfigname-${count.index + 1}"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    #    public_ip_address_id          = element(azurerm_public_ip.main.*.id, count.index)
  }
}


resource "azurerm_network_interface_security_group_association" "main" {
  count                     = length(var.name_count)
  network_interface_id      = element(azurerm_network_interface.main.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.main.*.id, count.index)
}



#data "azurerm_public_ip" "main" {
#  count               = length(var.name_count)
#  name                = element(var.name_count, count.index)
#  resource_group_name = var.resource_group_name
#  depends_on          = [azurerm_virtual_machine.appvm]
#}