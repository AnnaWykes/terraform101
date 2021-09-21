module "virtualmachine" {
  source        = "./vm"
  vm_name = "vm_name"
}

module "resource_groups" {
  source = "./resource_groups" 
}

module "virtual_machine" {
  source = "./vm" 
  vm_name = "vm_name" 
}

module "postgressql" {
  source = "./postgressql" 
}