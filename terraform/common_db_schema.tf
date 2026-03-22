resource "snowflake_database" "common_db" {
  provider     = snowflake.sysadmin
  name         = "COMMON"
  is_transient = false
}

resource "snowflake_schema" "common_common_schema" {
  provider            = snowflake.sysadmin
  database            = snowflake_database.common_db.name
  name                = "COMMON"
  with_managed_access = true
  is_transient        = false
  depends_on          = [snowflake_database.common_db]
}

resource "snowflake_database" "imported_inovex_db" {
  provider     = snowflake.sysadmin
  name         = "IMPORTED_INOVEX"
  is_transient = false
}

resource "snowflake_schema" "imported_inovex_customer_data_schema" {
  provider            = snowflake.sysadmin
  database            = snowflake_database.imported_inovex_db.name
  name                = "CUSTOMER_DATA"
  with_managed_access = true
  is_transient        = false
  depends_on          = [snowflake_database.imported_inovex_db]
}

resource "snowflake_schema" "imported_inovex_location_data_schema" {
  provider            = snowflake.sysadmin
  database            = snowflake_database.imported_inovex_db.name
  name                = "LOCATION_DATA"
  with_managed_access = true
  is_transient        = false
  depends_on          = [snowflake_database.imported_inovex_db]
}
