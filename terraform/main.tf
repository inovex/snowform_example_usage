terraform {
  backend "http" {

  }

  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 2.7.0"
    }
  }
}
