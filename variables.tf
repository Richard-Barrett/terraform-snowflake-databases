variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "comment" {
  type        = string
  description = "Database Comments"
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
