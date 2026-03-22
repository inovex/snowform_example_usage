module "logical_import_layer" {
  source = "github.com/inovex/snowform_logical_import_layer.git?ref=0.0.1"


  # Location for the stored procedure
  procedure_database = "COMMON"
  procedure_schema   = "COMMON"

  # Map source objects to logical layer targets
  source_to_target_mappings = {
    "CUSTOMER_LEADS_IMPORTED_DB.SNOWFORM_SCHEMA.CUSTOMER_LEADS" = {
      target_database = "IMPORTED_INOVEX"
      target_schema   = "CUSTOMER_DATA"
      target_name     = "CUSTOMER_LEADS"
    }
    "CUSTOMER_LEADS_IMPORTED_DB.SNOWFORM_SCHEMA.CUSTOMER_LOCATION" = {
      target_database = "IMPORTED_INOVEX"
      target_schema   = "CUSTOMER_DATA"
      target_name     = "CUSTOMER_LOCATION"
    }
    "CUSTOMER_LEADS_IMPORTED_DB.SNOWFORM_SCHEMA.INOVEX_LOCATIONS" = {
      target_database = "IMPORTED_INOVEX"
      target_schema   = "LOCATION_DATA"
      target_name     = "INOVEX_LOCATIONS"
    }
  }

  # Grant read access to roles
  database_role_grants = {
    "IMPORTED_INOVEX" = [
      "SYSADMIN",
    ],
  }

  providers = {
    snowflake.sysadmin      = snowflake.sysadmin
    snowflake.securityadmin = snowflake.securityadmin
  }

  depends_on = [
    snowflake_warehouse.xs_wh,
  ]
}
