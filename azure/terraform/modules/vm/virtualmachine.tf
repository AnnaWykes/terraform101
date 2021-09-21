# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }

variable "prefix" {
  default = "demo_terraform"
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

data "azurerm_resource_group" "terraform_demo_resource_group" {
  name= "${var.resource_group_name}"
}

resource "azurerm_virtual_network" "demo_terraform_vnet" {
  name                = "${var.prefix}_network"
  address_space       = ["10.0.0.0/16"]
  location            = "${data.azurerm_resource_group.terraform_demo_resource_group.location}"
  resource_group_name = "${data.azurerm_resource_group.terraform_demo_resource_group.name}"
}

resource "azurerm_subnet" "demo_terraform_vnet_subnet" {
  name                 = "${var.prefix}_vnet_subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = azurerm_virtual_network.demo_terraform_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "demo_terraform_network_interface" {
  name                = "${var.prefix}_nic"
  location            = "${data.azurerm_resource_group.terraform_demo_resource_group.location}"
  resource_group_name = "${data.azurerm_resource_group.terraform_demo_resource_group.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.demo_terraform_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "demo_terraform_vm" {
  name                  = "${var.prefix}_vm"
  location              = "${data.azurerm_resource_group.terraform_demo_resource_group.location}"
  resource_group_name   = "${data.azurerm_resource_group.terraform_demo_resource_group.name}"
  network_interface_ids = [azurerm_network_interface.demo_terraform_network_interface.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "demoterraformcomputer"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "development"
  }
}