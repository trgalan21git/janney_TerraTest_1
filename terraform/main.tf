# ---------- Azure (azurerm) ----------
resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location
  tags     = { purpose = "dab-learning", env = "test" }
}

resource "azurerm_databricks_workspace" "test" {
  name                        = var.workspace_name
  resource_group_name         = azurerm_resource_group.test.name
  location                    = azurerm_resource_group.test.location
  sku                         = "premium"
  managed_resource_group_name = "${var.resource_group_name}-managed"
  tags                        = { purpose = "dab-learning", env = "test" }
}

# ---------- Databricks account level ----------
resource "databricks_metastore_assignment" "test" {
  provider     = databricks.account
  workspace_id = azurerm_databricks_workspace.test.workspace_id
  metastore_id = var.metastore_id
}

resource "databricks_service_principal" "github" {
  provider     = databricks.account
  display_name = "sp-github-dab-test"
}

resource "databricks_service_principal_federation_policy" "github" {
  provider             = databricks.account
  service_principal_id = databricks_service_principal.github.id
  policy_id            = "github-main"
  oidc_policy = {
    issuer    = "https://token.actions.githubusercontent.com"
    audiences = ["https://github.com/${var.github_org}"]
    subject   = "repo:${var.github_repo}:ref:refs/heads/main"
  }
}

resource "databricks_mws_permission_assignment" "sp_test_workspace" {
  provider     = databricks.account
  workspace_id = azurerm_databricks_workspace.test.workspace_id
  principal_id = databricks_service_principal.github.id
  permissions  = ["USER"]
  depends_on   = [databricks_metastore_assignment.test]
}

# ---------- Databricks workspace level ----------
resource "databricks_catalog" "test" {
  provider      = databricks.workspace
  name          = var.test_catalog_name
  storage_root  = var.catalog_storage_root
  comment       = "Test catalog for DAB learning exercise"
  force_destroy = true # lets terraform destroy remove it even with tables
  depends_on    = [databricks_metastore_assignment.test]
}

resource "databricks_schema" "test" {
  provider      = databricks.workspace
  catalog_name  = databricks_catalog.test.name
  name          = var.test_schema_name
  force_destroy = true
}

resource "databricks_grants" "catalog" {
  provider = databricks.workspace
  catalog  = databricks_catalog.test.name
  grant {
    principal  = databricks_service_principal.github.application_id
    privileges = ["USE_CATALOG"]
  }
  depends_on = [databricks_mws_permission_assignment.sp_test_workspace]
}

resource "databricks_grants" "schema" {
  provider = databricks.workspace
  schema   = "${databricks_catalog.test.name}.${databricks_schema.test.name}"
  grant {
    principal  = databricks_service_principal.github.application_id
    privileges = ["USE_SCHEMA", "CREATE_TABLE", "SELECT", "MODIFY"]
  }
  depends_on = [databricks_mws_permission_assignment.sp_test_workspace]
}
