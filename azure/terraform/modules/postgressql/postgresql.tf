

data "azurerm_resource_group" "resource_group" {
  name= "${var.resource_group_name}"
}

resource "azurerm_postgresql_server" "demo_postgresql_server" {
  name                = "${var.prefix}-psqlserver"
  location            = "West Europe"
  resource_group_name = "${data.azurerm_resource_group.resource_group.name}"

  administrator_login          = "psqladminun"
  administrator_login_password = "${var.postgresql_pwd}"

  sku_name   = "GP_Gen5_4"
  version    = "9.6"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}