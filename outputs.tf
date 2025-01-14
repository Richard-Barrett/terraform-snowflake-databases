output "read_access" {
  description = "Read access granted to the database on selected warehouse on snowflake_role.name"
  value       = snowflake_account_role.read.name
}

output "write_access" {
  description = "Write access granted to the database on selected warehouse snowflake_role.name"
  value       = snowflake_account_role.write.name
}
