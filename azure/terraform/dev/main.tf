

terraform {
  backend "azurerm" {
    resource_group_name   = "demoterraformstate"
    storage_account_name  = "bdldnterraformtfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

module "resource_groups" {
  source = "../modules/resource_groups" 
}

module "storage_accounts" {
  source = "../modules/storage_accounts" 
  resource_group_name = "${module.resource_groups.resource_group_name}"
  resource_group_location = "${module.resource_groups.resource_group_location}"
  depends_on = [
    module.resource_groups
  ]
}

module "virtual_machine" {
  source = "../modules/vm" 
  vm_name = "vm_name"
  resource_group_name = "${module.resource_groups.resource_group_name}"
  resource_group_location = "${module.resource_groups.resource_group_location}"
  depends_on = [
    module.resource_groups
  ]
}

module "postgressql" {
  source = "../modules/postgressql" 
  resource_group_name = "${module.resource_groups.resource_group_name}"
  resource_group_location = "${module.resource_groups.resource_group_location}"
  postgresql_pwd = var.postgresql_pwd
  depends_on = [
  module.resource_groups
  ]
}

#terraform plan -out=plan.out
#terraform show -json plan.out > plan.json
#terraform graph | dot -Tsvg > graph.svg
#$env:ARM_ACCESS_KEY=
#terraform apply -destroy
#terraform force-unlock