variable "prefix" {
  default = "demo_terraform"
}

resource "azurerm_resource_group" "demo_terraform_resources" {
  name     = "${var.prefix}_resources"
  location = "uksouth" #westeurope
}

output "resource_group_name" {
  value = azurerm_resource_group.demo_terraform_resources.name
}

output "resource_group_location" {
  value = azurerm_resource_group.demo_terraform_resources.location
}

#terraform import module.resource_groups.azurerm_resource_group.demo_terraform_resources /subscriptions/167ab168-84f9-43c4-b197-8bfbf27bf6d1/resourceGroups/demo_terraform_resources/
