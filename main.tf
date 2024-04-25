terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.89.0"
    }
  }
}

locals {
  metadata_access_types = toset([
    "USAGE",
    "MONITOR"
  ])
}

resource "snowflake_database" "this" {
  name    = var.database_name
  comment = var.comment

  data_retention_time_in_days = var.data_retention_time_in_days
}

resource "snowflake_role" "read" {
  name    = "${upper(var.database_name)}_DB_RO"
  comment = var.comment
}

resource "snowflake_role" "write" {
  name    = "${upper(var.database_name)}_DB_RW"
  comment = var.comment
}

// DATABASE GRANT AND ACCESS FOR RO AND RW ROLES
resource "snowflake_database_grant" "grant" {
  for_each      = local.metadata_access_types
  database_name = snowflake_database.this.name

  privilege = each.key
  roles     = [snowflake_role.read.name, snowflake_role.write.name]

  shares                 = toset(var.account_shares)
  with_grant_option      = var.with_grant_option
  enable_multiple_grants = var.enable_multiple_grants
}

// Write Access Grants for Schemas, Tables, Views
resource "snowflake_database_grant" "create" {
  database_name          = snowflake_database.this.name
  privilege              = "CREATE SCHEMA"
  roles                  = [snowflake_role.write.name]
  with_grant_option      = false
  enable_multiple_grants = true
}

// PERMISSIONS SECTION:
// Read Access Grants for Schemas, Tables, Views
resource "snowflake_schema_grant" "read" {
  for_each = var.schema_read_privileges

  database_name          = snowflake_database.this.name
  on_future              = true
  privilege              = each.value
  roles                  = [snowflake_role.read.name, snowflake_role.write.name]
  with_grant_option      = false
  enable_multiple_grants = true

}

resource "snowflake_table_grant" "read" {
  for_each = var.read_permissions

  database_name          = snowflake_database.this.name
  on_future              = true
  privilege              = each.value
  roles                  = [snowflake_role.read.name, snowflake_role.write.name]
  with_grant_option      = false
  enable_multiple_grants = true
}

resource "snowflake_view_grant" "read" {
  for_each = var.read_permissions

  database_name          = snowflake_database.this.name
  on_future              = true
  privilege              = each.value
  roles                  = [snowflake_role.read.name, snowflake_role.write.name]
  with_grant_option      = false
  enable_multiple_grants = true
}

// WRITE PERMS FOR SCHEMAS, TABLES, VIEWS
resource "snowflake_schema_grant" "create" {
  for_each = var.schema_object_types

  database_name     = snowflake_database.this.name
  on_future         = true
  privilege         = "CREATE ${each.value}"
  roles             = [snowflake_role.write.name]
  with_grant_option = false

  enable_multiple_grants = true
}

resource "snowflake_schema_grant" "all" {
  for_each = var.schema_write_privileges

  database_name     = snowflake_database.this.name
  on_future         = true
  privilege         = each.value
  roles             = [snowflake_role.write.name]
  with_grant_option = false

  enable_multiple_grants = true
}

resource "snowflake_table_grant" "write" {
  for_each = var.write_permissions

  database_name          = snowflake_database.this.name
  on_future              = true
  privilege              = each.value
  roles                  = [snowflake_role.write.name]
  with_grant_option      = false
  enable_multiple_grants = true
}
