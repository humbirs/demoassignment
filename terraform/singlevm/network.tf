
##Create public ip
#resource "azurerm_public_ip" "main" {
#  name                = "${var.prefix}-${var.computername}-pip"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  allocation_method   = "Dynamic"
#  domain_name_label   = "${var.prefix}-url-${var.computername}"
#}

# Create a Network Security Group with some rules
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-${var.computername}-NSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80", "443"]
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
  name                = "${var.prefix}-${var.computername}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.prefix}-${var.computername}-ip"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    #    public_ip_address_id          = [azurerm_public_ip.main.id]
  }
}


resource "azurerm_network_interface_security_group_association" "main" {

  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}



#data "azurerm_public_ip" "main" {
#  name                = "${var.prefix}-${var.computername}-pip"
#  resource_group_name = var.resource_group_name
#  depends_on          = [azurerm_virtual_machine.appvm]
#}