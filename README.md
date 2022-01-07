# Getting Started Guide 
A guide to using Terraform to control cloud deployments

This repo is intended to help you get started using Terraform for Azure. Below is a step by step guide to getting started. You will also find a video here https://vimeo.com/641231070 that demos, and explains the content of this repo: 

### Azure

1. Make sure you have terraform and the Azure CLI installed https://learn.hashicorp.com/tutorials/terraform/install-cli, https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
2. It is recommended you use VSCode as your IDE, though this is open to preference
3. Once you have a copy of the repo locally open this in your IDE, open a terminal window and navigate to azure/dev
4. It is important you decide whether to store your Terraform State file locally or in blob store. If you are working locally delete the following from `main.tf` : `terraform {
  backend "azurerm" {
    resource_group_name   = "demoterraformstate"
    storage_account_name  = "bdldnterraformtfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}`. If you are working remotely amend the aforementioned terraform accordingly to point to your blob store 
5. Now you need to tell terraform where your Azure instance is. In vars.tf observer all the variables expected: `subscription_id`, `client_id` (Service Principle ID), `client_secret`, `tenant_id` (your Azure Active Directory ID), `postgresql_pwd` (this can be anything you like)
6. For the above variables you have a few options on how to provide them. One of the simplest is to create a `terraform.tfvars` file with all values specified (this is a local file that should not be checked in). An example entry would be `postgresql_pwd = "MyPassword12345"`
7. In your terminal now run `terraform init`, observe the output. This has 'initialised' your terraform project 
8. In your terminal now run `terraform plan`. You should see a response (a plan) telling you what is going to be added to your Azure instance
9. In your terminal now run `terraform apply`, this will deploy everything to your Azure instance

### Databricks

1. Make sure you have terraform and the Azure CLI installed https://learn.hashicorp.com/tutorials/terraform/install-cli, https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
2. It is recommended you use VSCode as your IDE, though this is open to preference
3. Once you have a copy of the repo locally open this in your IDE,  open a terminal window and navigate to databricks/terraform
4. Terraform will use current Azure account you are logged into and deploy there using your logged in user account, this is diffferent to above where we are using a Service Principle. Consequently, in your terminal run az login (Azure CLI command), and make sure you are logged in, and under the correct Azure instance 
5. In vars.tf observer all the variables expected: resource_group_name = "terraformDbxResourceGroup"
`azure_region`, `databricks_name`, `databricks_managed_resource_group_name`, `databricks_sku_name`, `secret_scope_name`, `databricks_token_name`, `cluster_name`
`spark_version`, `node_type_id`, `autotermination_minutes`, `notebook_path`
6. For the variables in vars.tf you have a few options on how to provide them. One of the simplest is to create a `terraform.tfvars` file with all values specified (this is a local file that should not be checked in). An example entry would be `cluster_name = "terraformdatabricks-cluster"`
7. In your terminal now run `terraform init`, observe the output. This has 'initialised' your terraform project 
8. In your terminal now run `terraform plan`. You should see a response (a plan) telling you what is going to be added to your Azure instance
9. In your terminal now run `terraform apply`, this will create a Databricks instance in your Azure instance



