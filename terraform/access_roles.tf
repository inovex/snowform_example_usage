module "access_roles" {
  source = "github.com/inovex/snowform_access_roles.git?ref=0.0.1"
  db     = snowflake_database.common_db
  data_layers = [
    {
      name = "COMMON"
    }
  ]
  depends_on = [
    snowflake_database.common_db,
    snowflake_schema.common_common_schema,
  ]
  providers = {
    snowflake.useradmin     = snowflake.useradmin
    snowflake.sysadmin      = snowflake.sysadmin
    snowflake.securityadmin = snowflake.securityadmin
  }
}

# SECURITYADMIN needs to be allowed to use COMMON schema for network policies
# resource "snowflake_execute" "grant_create_network_rule_to_securityadmin" {
#   provider = snowflake.sysadmin
#   execute  = "GRANT CREATE NETWORK RULE ON SCHEMA ${snowflake_database.common_db.name}.${snowflake_schema.common_common_schema.name} TO ROLE SECURITYADMIN;"
#   revert   = "REVOKE CREATE NETWORK RULE ON SCHEMA ${snowflake_database.common_db.name}.${snowflake_schema.common_common_schema.name} FROM ROLE SECURITYADMIN;"
# }
