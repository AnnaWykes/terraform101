variable "postgresql_pwd"{
  type = string
  sensitive = true
}

variable "prefix" {
  default = "demo-terraform"
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}
