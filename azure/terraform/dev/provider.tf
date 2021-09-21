
### Get Azure Terraform provider and mark as required ###
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

### Configure the Microsoft Azure Provider ###
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id 
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#https://hieven.github.io/terraform-visual/
#https://medium.com/vmacwrites/tools-to-visualize-your-terraform-plan-d421c6255f9f
