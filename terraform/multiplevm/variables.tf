variable "resource_group_name" {
  description = "The name of your Azure Resource Group."
  default     = "Intelligence_and_Targeting"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "westeurope"
}

variable "virtual_network_name" {
  description = "The name for your virtual network."
  default     = "Intelligence_and_Targeting"
}

variable "azurerm_subnet" {
  description = "The name for your subnet network."
  default     = "snet-Intelligence-and-Targeting-002"
}

variable "golden_image" {
  description = "Name of the Packer golden OS image file"
  default     = "Borders-AlmaLinux8-Base-ImageV1.0"
}


variable "prefix" {
  default = "humdemo-azure"
}

variable "name_count" { default = ["humweb01"] }
#variable "name_count" { default = ["humweb01", "humweb02"] }

variable "machine_type_PROD" { default = "Standard_DS2_v2" }
variable "machine_type_DEV" { default = "Standard_DS1_v2" }
variable "environment" { default = "production" }
#variable "publisher" { default = "OpenLogic" }
#variable "offer" { default = "CentOS-LVM" }
#variable "sku" { default = "7-lvm-gen2" }
#variable "version" { default = "latest" }



variable "admin_username" {
  description = "Administrator user name"
  default     = "newadmin"
}

variable "admin_password" {
  description = "Administrator password"
  default     = "C0mplexP@ss!"
}

variable "tags" {
  type = map(any)
  default = {
    budget_allocated = "yes"
    CreatedBy        = "humbir"
  }
}


variable "clientsecret" {
  default = ""
}

variable "clientid" {
  default = ""
}

variable "subscriptionid" {
  default = ""
}

variable "tenantid" {
  default = ""
}
