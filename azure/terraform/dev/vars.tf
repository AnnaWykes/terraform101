
variable "subscription_id"{
  type      = string
  sensitive = true
}

variable "client_id"{
  type      = string
  sensitive = true
}

variable "client_secret"{
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type      = string
  sensitive = true
}

variable "postgresql_pwd" {
  type      = string
  sensitive = true
}