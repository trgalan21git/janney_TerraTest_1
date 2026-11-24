variable "subscription_id" {
  type        = string
  description = "Azure subscription that will hold the test workspace"
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID (from the account console)"
}

variable "metastore_id" {
  type        = string
  description = "Existing Unity Catalog metastore in South Central US"
}

variable "location" {
  type    = string
  default = "southcentralus"
}

variable "resource_group_name" {
  type    = string
  default = "rg-dab-test-scus"
}

variable "workspace_name" {
  type    = string
  default = "dbw-dab-test-scus"
}

variable "github_org" {
  type    = string
  default = "trgalan21git"
}

variable "github_repo" {
  type    = string
  default = "trgalan21git/janney_TerraTest_1"
}

variable "test_catalog_name" {
  type    = string
  default = "dab_test"
}

variable "test_schema_name" {
  type    = string
  default = "hello_dab"
}

variable "catalog_storage_root" {
  type        = string
  default     = null
  description = "Only needed if the metastore has no default storage root"
}
