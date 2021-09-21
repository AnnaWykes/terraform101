  terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~>2.31.1"
      }
      databricks = {
        source  = "databrickslabs/databricks"
        version = "0.3.2"
      }
    }
  }

provider "azurerm" {
      features {}
}

provider "databricks" {
    azure_workspace_resource_id = azurerm_databricks_workspace.databricks_workspace.id
}


/* Create a resource group for our databricks workspace to be deployed to*/
resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.azure_region
}

/* Create a Databricks workspace */
resource "azurerm_databricks_workspace" "databricks_workspace" {
    name                        = var.databricks_name
    resource_group_name         = azurerm_resource_group.rg.name
    managed_resource_group_name = var.databricks_managed_resource_group_name
    location                    = var.azure_region
    sku                         = var.databricks_sku_name
}


/* Create a Databricks secret scope  */
resource "databricks_secret_scope" "secret_scope" {
    name = var.secret_scope_name
    initial_manage_principal = "users"
}


/* Create databricks token */
resource "databricks_token" "pat" {
    comment          = "Created from ${abspath(path.module)}"
    lifetime_seconds = 3600
}

/* Adds Databricks secret scope to the workspace and generate a personal access token (pat) for 1 hour then store as a secret in the scope. */

resource "databricks_secret" "token" {
    string_value = databricks_token.pat.token_value
    scope        = databricks_secret_scope.secret_scope.name
    key          = var.databricks_token_name
}

/* Create databricks cluster */
resource "databricks_cluster" "databricks_cluster_01" {
    cluster_name            = var.cluster_name
    spark_version           = var.spark_version
    node_type_id            = var.node_type_id
    autotermination_minutes = var.autotermination_minutes
    autoscale {
      min_workers = 1
      max_workers = 2
    }
    # Create Libraries
    library {
      pypi {
          package = "pyodbc"
          }
    }
    library {
      maven {
        coordinates = "com.microsoft.azure:spark-mssql-connector_2.12_3.0:1.0.0-alpha"
      }
    }
    custom_tags = {
      Department = "Data Engineering"
    }

    azure_attributes {
      availability       = "ON_DEMAND_AZURE"
      first_on_demand    = 1
      spot_bid_max_price = -1 
    }
  }

/* Create Databricks notebook */
resource "databricks_notebook" "notebook" {
    content_base64 = base64encode("print('Welcome to Databricks-Labs notebook')")
    path      = var.notebook_path
    language  = "PYTHON"
  }


