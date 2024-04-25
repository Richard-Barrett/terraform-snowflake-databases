<img align="right" width="60" height="60" src="images/terraform.png">

# tf-snowflake-databases module

This is a repository that makes databases and database roles.

- snowflake_database.this
- snowflake_database_grant.create
- snowflake_database_grant.grant
- snowflake_role.read
- snowflake_role.write
- snowflake_schema_grant.all
- snowflake_schema_grant.create
- snowflake_schema_grant.read
- snowflake_table_grant.read
- snowflake_table_grant.write
- snowflake_view_grant.read

## Overview

In general this repository is a module that can be used for making databases via a digestable module. The module in question creates two roles:

- snowflake_role.read
- snowflake_role.write

The roles are consecutive to `RO` for read permissions and `RW` for read/write permissions.

Example CICD with `BitBucket` and `Codefresh`:

![Image](./images/diagram.png)

## Usage

To use the module you will need to use the following:

```hcl
module "snowflake_database_consumption" {
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"

  database_name    = "CONSUMPTION"
  database_comment = "CONSUMPTION Database"
}
```

## Examples

There may be times where you want to specify more than what is needed and forloop through a bunch of roles or what not.
This is particularly useful if you are using SCIM Provisioning to control your roles. As such you could see about controlling the roles via some form of mapping and iterating through each role that is created by the IDP to create databases for each role:

```hcl
module "snowflake_database" {
  for_each = toset(local.okta_role_databases)
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"

  database_name = "TEAM_${each.value}"
  comment       = "Database for ${each.value} Team"
}
```

The above shows the use case, whereby you would want a `locals.tf` with some mapping for the `okta_role_databases`.

```hcl
locals {
  okta_roles = {
    OKTA_SNOWFLAKE_TEAMNAME_READ                  = ["TEAM_TEAMNAME_DB_RO"]
    OKTA_SNOWFLAKE_TEAMNAME_MODIFY                = ["TEAM_TEAMNAME_DB_RW"]
  }
  okta_role_databases = distinct(flatten([
    for role in keys(local.okta_roles) : [
      replace(replace(replace(role, "OKTA_SNOWFLAKE_USPROD_", ""), "_MODIFY", ""), "_READ", "")
    ]
  ]))
}
```

As you can see this module is very good at baking on the databases, database_roles, and database_grants.

The only required values are `database_name` and `database_comment`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | 0.75.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_database.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database) | resource |
| [snowflake_database_grant.create](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_database_grant.grant](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_role.read](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role) | resource |
| [snowflake_role.write](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role) | resource |
| [snowflake_schema_grant.all](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_schema_grant.create](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_schema_grant.read](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_table_grant.read](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/table_grant) | resource |
| [snowflake_table_grant.write](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/table_grant) | resource |
| [snowflake_view_grant.read](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/view_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_shares"></a> [account\_shares](#input\_account\_shares) | Snowflake Account Shares that for Database Shares Across Accounts | `set(string)` | `[]` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Database Comments | `string` | n/a | yes |
| <a name="input_data_retention_time_in_days"></a> [data\_retention\_time\_in\_days](#input\_data\_retention\_time\_in\_days) | Snowflake Database data retention time in days | `string` | `"7"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the database | `string` | n/a | yes |
| <a name="input_enable_multiple_grants"></a> [enable\_multiple\_grants](#input\_enable\_multiple\_grants) | (Boolean) When this is set to true, multiple grants of the same type can be created. This will cause Terraform to not revoke grants applied to roles and objects outside Terraform. | `bool` | `true` | no |
| <a name="input_read_permissions"></a> [read\_permissions](#input\_read\_permissions) | Read Permissions for RBAC | `set(string)` | <pre>[<br>  "SELECT"<br>]</pre> | no |
| <a name="input_schema_object_types"></a> [schema\_object\_types](#input\_schema\_object\_types) | n/a | `set(string)` | <pre>[<br>  "TABLE",<br>  "VIEW"<br>]</pre> | no |
| <a name="input_schema_read_privileges"></a> [schema\_read\_privileges](#input\_schema\_read\_privileges) | Schema Privileges | `set(string)` | <pre>[<br>  "USAGE",<br>  "MONITOR"<br>]</pre> | no |
| <a name="input_schema_write_privileges"></a> [schema\_write\_privileges](#input\_schema\_write\_privileges) | Schema Privileges | `set(string)` | <pre>[<br>  "ADD SEARCH OPTIMIZATION",<br>  "CREATE EXTERNAL TABLE",<br>  "CREATE FILE FORMAT",<br>  "CREATE FUNCTION",<br>  "CREATE MASKING POLICY",<br>  "CREATE MATERIALIZED VIEW",<br>  "CREATE PIPE",<br>  "CREATE PROCEDURE",<br>  "CREATE ROW ACCESS POLICY",<br>  "CREATE SEQUENCE",<br>  "CREATE STAGE",<br>  "CREATE STREAM",<br>  "CREATE TABLE",<br>  "CREATE TAG",<br>  "CREATE TASK",<br>  "CREATE TEMPORARY TABLE",<br>  "CREATE VIEW",<br>  "MODIFY",<br>  "MONITOR",<br>  "USAGE"<br>]</pre> | no |
| <a name="input_with_grant_option"></a> [with\_grant\_option](#input\_with\_grant\_option) | Ignore Edition Check | `bool` | `true` | no |
| <a name="input_write_permissions"></a> [write\_permissions](#input\_write\_permissions) | Read Permissions for RBAC | `set(string)` | <pre>[<br>  "SELECT",<br>  "INSERT",<br>  "UPDATE",<br>  "DELETE"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_read_access"></a> [read\_access](#output\_read\_access) | Read access granted to the database on selected warehouse on snowflake\_role.name |
| <a name="output_write_access"></a> [write\_access](#output\_write\_access) | Write access granted to the database on selected warehouse snowflake\_role.name |
<!-- END_TF_DOCS -->
