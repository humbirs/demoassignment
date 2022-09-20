
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "Intelligence_and_Targeting"
    storage_account_name = "humterraformbackend01"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    #access_key           = ""       use environment variable to secure access key like export ARM_ACCESS_KEY='adsadsajhdja'
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  #  subscription_id = var.subscriptionid
  #  client_id       = var.clientid
  #  client_secret   = var.clientsecret
  #  tenant_id       = var.tenantid  
  features {}
}
