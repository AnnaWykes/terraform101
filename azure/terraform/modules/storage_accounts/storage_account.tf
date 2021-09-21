variable "prefix" {
  default = "demo_terraform"
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

data "azurerm_resource_group" "rg" {
  name= "${var.resource_group_name}"
}

resource "azurerm_storage_account" "demo_terraform_storage_account" {
  name                     = "bdldndemoterrastorage"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "demo_terraform_container" {
  name                  = "demoterraformcontainer"
  storage_account_name  = azurerm_storage_account.demo_terraform_storage_account.name
  container_access_type = "private"
}