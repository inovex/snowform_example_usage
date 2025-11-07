resource "snowflake_database" "common_db" {
  provider     = snowflake.sysadmin
  name         = "COMMON"
  is_transient = false
}
