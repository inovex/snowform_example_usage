provider "snowflake" {
  organization_name = "ERUVBJC"
  account_name      = "INOVEX_TF_MODULES"
  user              = var.SNOWFLAKE_DEPLOY_USER
  # kics-scan ignore-line - to prevent kics-interpretation of base64decode.. as hard-coded password
  private_key              = base64decode(var.SNOWFLAKE_DEPLOY_PRIVATE_KEY_BASE64)
  private_key_passphrase   = var.SNOWFLAKE_DEPLOY_PRIVATE_KEY_PASSPHRASE
  role                     = "SYSADMIN"
  alias                    = "sysadmin"
  authenticator            = "SNOWFLAKE_JWT"
  driver_tracing           = "debug"
  preview_features_enabled = ["snowflake_notification_integration_resource", "snowflake_procedure_sql_resource"]
}

provider "snowflake" {
  organization_name = "ERUVBJC"
  account_name      = "INOVEX_TF_MODULES"
  user              = var.SNOWFLAKE_DEPLOY_USER
  # kics-scan ignore-line - to prevent kics-interpretation of base64decode.. as hard-coded password
  private_key            = base64decode(var.SNOWFLAKE_DEPLOY_PRIVATE_KEY_BASE64)
  private_key_passphrase = var.SNOWFLAKE_DEPLOY_PRIVATE_KEY_PASSPHRASE
  role                   = "USERADMIN"
  alias                  = "useradmin"
  authenticator          = "SNOWFLAKE_JWT"
  driver_tracing         = "debug"
}

provider "snowflake" {
  organization_name = "ERUVBJC"
  account_name      = "INOVEX_TF_MODULES"
  user              = var.SNOWFLAKE_DEPLOY_USER
  # kics-scan ignore-line - to prevent kics-interpretation of base64decode.. as hard-coded password
  private_key              = base64decode(var.SNOWFLAKE_DEPLOY_PRIVATE_KEY_BASE64)
  private_key_passphrase   = var.SNOWFLAKE_DEPLOY_PRIVATE_KEY_PASSPHRASE
  role                     = "SECURITYADMIN"
  alias                    = "securityadmin"
  authenticator            = "SNOWFLAKE_JWT"
  driver_tracing           = "debug"
  preview_features_enabled = ["snowflake_procedure_sql_resource", "snowflake_network_rule_resource", "snowflake_network_policy_attachment_resource", "snowflake_authentication_policy_resource", "snowflake_user_authentication_policy_attachment_resource"]
}
