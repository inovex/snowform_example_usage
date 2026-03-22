resource "snowflake_account_role" "consumer" {
  provider = snowflake.securityadmin
  name     = "CONSUMER_ROLE"
  comment  = "Consumer functional role"
}
