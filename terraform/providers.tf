# Azure Resource Manager: builds the resource group and workspace
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Databricks ACCOUNT level: metastore assignment, service principal,
# federation policy, workspace assignment
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
  auth_type  = "azure-cli"
}

# Databricks WORKSPACE level: catalog, schema, grants in the new test workspace
provider "databricks" {
  alias                       = "workspace"
  host                        = "https://${azurerm_databricks_workspace.test.workspace_url}"
  azure_workspace_resource_id = azurerm_databricks_workspace.test.id
  auth_type                   = "azure-cli"
}