# Examples

### Basic Usage

Here is a basic example of how to use the module to create a Snowflake database:

```hcl
module "snowflake_database_basic" {
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"

  database_name = "BASIC_DB"
  comment       = "Basic Database"
}

## Advanced Usage with Role Mapping

In this example, we demonstrate how to use the module to create multiple databases based on roles provisioned by an IDP:

```hcl
module "snowflake_database_advanced" {
  for_each = toset(local.okta_role_databases)
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"

  database_name = "TEAM_${each.value}"
  comment       = "Database for ${each.value} Team"
}
```

## Using with CICD

You can integrate this module with your CICD pipeline using BitBucket and Codefresh:

```hcl
module "snowflake_database_cicd" {
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"

  database_name = "CICD_DB"
  comment       = "Database for CICD"
}
```

For more detailed examples, please refer to the [examples](https://github.com/Richard-Barrett/terraform-snowflake-databases/tree/main/examples) directory.
