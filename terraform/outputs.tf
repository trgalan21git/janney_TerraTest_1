output "test_workspace_url" {
  value = "https://${azurerm_databricks_workspace.test.workspace_url}"
}

output "sp_application_id" {
  value = databricks_service_principal.github.application_id
}

output "test_catalog" {
  value = databricks_catalog.test.name
}

output "test_schema" {
  value = databricks_schema.test.name
}