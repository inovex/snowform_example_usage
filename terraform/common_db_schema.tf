resource "snowflake_warehouse" "xs_wh" {
  provider       = snowflake.sysadmin
  name           = "XS_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

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
