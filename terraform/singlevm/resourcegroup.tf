
#resource "azurerm_resource_group" "main" {
#  name     = var.name
#  location = var.location
#}

#resource "azurerm_virtual_network" "main" {
#  name                = "Intelligence_and_Targeting"
#  address_space       = ["10.0.0.0/16"]
#  location            = azurerm_resource_group.main.location
#  resource_group_name = azurerm_resource_group.main.name
#  depends_on = [azurerm_resource_group.main]
#}

#resource "azurerm_subnet" "internal" {
#  name                 = "internal"
#  resource_group_name  = azurerm_resource_group.main.name
#  virtual_network_name = azurerm_virtual_network.main.name
#  address_prefixes     = ["10.0.2.0/24"]
#}


# Locate the existing custom/golden image
data "azurerm_image" "search" {
  name                = var.golden_image
  resource_group_name = "Common_Services"
}

# Create a Resource Group for the new Virtual Machine.
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "sourcevnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.main.name
}

# Create a Subnet within the Virtual Network
data "azurerm_subnet" "internal" {
  name                 = var.azurerm_subnet
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}
