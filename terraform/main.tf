terraform {
  required_version = ">= 1.7"

  # State lives in GCS with built-in locking, see "Terraform State Backend (GCS)" in README.md
  backend "gcs" {
    bucket = "quickstart-1592892564690-snowform-tfstate"
    prefix = "snowform_example_usage"
  }

  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 2.14.0"
    }
  }
}
