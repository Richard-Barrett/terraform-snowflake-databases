terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 1.0.1"
    }
  }
}

provider "snowflake" {}

module "snowflake_database_consumption" {
  source  = "../../"

  database_name    = "CONSUMPTION"
  comment = "CONSUMPTION Database"
}
