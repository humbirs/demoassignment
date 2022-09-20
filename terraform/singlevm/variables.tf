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

variable "computername" { default = "web01" }

variable "machine_type_PROD" { default = "Standard_DS2_v2" }
variable "machine_type_DEV" { default = "Standard_DS1_v2" }
variable "environment" { default = "production" }
#variable "publisher" { default = "OpenLogic" }
#variable "offer" { default = "CentOS-LVM" }
#variable "sku" { default = "7-lvm-gen2" }
#variable "version" { default = "latest" }
variable "publickey" { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Sk30StE71z7fRqwsjbVHggFUYgDe0q/wbuxFdlQ3gH7CTwc+cEuJ7h0jfvKxMVuZ+iBfUSO4QUke0RpjD+qzURDnj4SG12f8CpwiGS7a1ghX2sE2Q+5eK1HdN60tfmUZceS3cfQdFqUCQhbWmZbdnRfnDeq9LzSkrSkouMhizyaqY4yNiHL5t8yVeCEAFupXNL2FmVjiCR4/wAKNQgY0ai2msVlP9o5q+vPRngArzHaiFuqPKt5/f5DsGkDJZ/ZhhE0g+UvCENzRzzcGP7VNwcH3SKMVCbwSzaKZeSM17lgNsEARnHLS6WoUQiQaV7a+dvjEimy/rYgel7Q3kkRv jenkins@humbir"}

variable "admin_username" {
  description = "Administrator user name"
  default     = "newadmin"
}

variable "admin_password" {
  description = "Administrator password"
  default     = "N3wP@ss!"
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

variable "domain" {
  type        = string
  description = "The primary domain name for the certificate."
  default     = "web01.example.com"
}
