variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "comment" {
  type        = string
  description = "Database Comments"
}

variable "account_shares" {
  type        = set(string)
  description = "Snowflake Account Shares that for Database Shares Across Accounts"
  default     = []
}

variable "data_retention_time_in_days" {
  type        = string
  description = "Snowflake Database data retention time in days"
  default     = "7"
}

variable "with_grant_option" {
  type        = bool
  description = "Ignore Edition Check"
  default     = true
}

variable "enable_multiple_grants" {
  type        = bool
  description = "(Boolean) When this is set to true, multiple grants of the same type can be created. This will cause Terraform to not revoke grants applied to roles and objects outside Terraform."
  default     = true
}

variable "schema_write_privileges" {
  type        = set(string)
  description = "Schema Privileges"
  default = [
    "ADD SEARCH OPTIMIZATION",
    "CREATE EXTERNAL TABLE",
    "CREATE FILE FORMAT",
    "CREATE FUNCTION",
    "CREATE MASKING POLICY",
    "CREATE MATERIALIZED VIEW",
    "CREATE PIPE",
    "CREATE PROCEDURE",
    "CREATE ROW ACCESS POLICY",
    "CREATE SEQUENCE",
    "CREATE STAGE",
    "CREATE STREAM",
    "CREATE TABLE",
    "CREATE TAG",
    "CREATE TASK",
    "CREATE TEMPORARY TABLE",
    "CREATE VIEW",
    "MODIFY",
    "MONITOR",
    "USAGE"
  ]
}

variable "schema_read_privileges" {
  type        = set(string)
  description = "Schema Privileges"
  default = [
    "USAGE",
    "MONITOR"
  ]
}

variable "read_permissions" {
  type        = set(string)
  description = "Read Permissions for RBAC"
  default = [
    "SELECT",
  ]
}

variable "write_permissions" {
  type        = set(string)
  description = "Read Permissions for RBAC"
  default = [
    "SELECT",
    "INSERT",
    "UPDATE",
    "DELETE"
  ]
}

variable "schema_object_types" {
  type = set(string)
  default = [
    "TABLE",
    "VIEW"
  ]
}
