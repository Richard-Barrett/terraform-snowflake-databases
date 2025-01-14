terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 1.0.1"
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

resource "snowflake_account_role" "read" {
  name    = "${upper(var.database_name)}_DB_RO"
  comment = var.comment
}

resource "snowflake_account_role" "write" {
  name    = "${upper(var.database_name)}_DB_RW"
  comment = var.comment
}

// DATABASE GRANT AND ACCESS FOR RO AND RW ROLES
resource "snowflake_grant_privileges_to_account_role" "grant" {
  for_each = local.metadata_access_types

  privileges        = [each.key]
  account_role_name = snowflake_account_role.read.name # Grant privileges to the read role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = var.with_grant_option
}

// Write Access Grants for Schemas, Tables, Views
resource "snowflake_grant_privileges_to_account_role" "create" {
  privileges        = ["CREATE SCHEMA"]
  account_role_name = snowflake_account_role.write.name # Grant privileges to the write role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}

// PERMISSIONS SECTION:
// Read Access Grants for Schemas, Tables, Views
resource "snowflake_grant_privileges_to_account_role" "read" {
  for_each = var.schema_read_privileges

  privileges        = [each.value]
  account_role_name = snowflake_account_role.read.name # Grant privileges to the read role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}

resource "snowflake_grant_privileges_to_account_role" "table_read" {
  for_each = var.read_permissions

  privileges        = [each.value]
  account_role_name = snowflake_account_role.read.name # Grant privileges to the read role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}

resource "snowflake_grant_privileges_to_account_role" "view_read" {
  for_each = var.read_permissions

  privileges        = [each.value]
  account_role_name = snowflake_account_role.read.name # Grant privileges to the read role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}

// WRITE PERMS FOR SCHEMAS, TABLES, VIEWS
resource "snowflake_grant_privileges_to_account_role" "schema_create" {
  for_each = var.schema_object_types

  privileges        = ["CREATE ${each.value}"]
  account_role_name = snowflake_account_role.write.name # Grant privileges to the write role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}

resource "snowflake_grant_privileges_to_account_role" "schema_all" {
  for_each = var.schema_write_privileges

  privileges        = [each.value]
  account_role_name = snowflake_account_role.write.name # Grant privileges to the write role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}

resource "snowflake_grant_privileges_to_account_role" "table_write" {
  for_each = var.write_permissions

  privileges        = [each.value]
  account_role_name = snowflake_account_role.write.name # Grant privileges to the write role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }
  with_grant_option = false
}
