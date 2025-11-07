provider "snowflake" {
  organization_name = "ERUVBJC"
  account_name      = "master_data_quality.privatelink"
  user              = var.snowflake_deploy_user
  # kics-scan ignore-line - to prevent kics-interpretation of base64decode.. as hard-coded password
  private_key              = base64decode(var.snowflake_deploy_private_key_base64)
  private_key_passphrase   = var.snowflake_deploy_private_key_passphrase
  role                     = "SYSADMIN"
  alias                    = "sysadmin"
  authenticator            = "SNOWFLAKE_JWT"
  preview_features_enabled = ["snowflake_notification_integration_resource", "snowflake_procedure_sql_resource"]
}

provider "snowflake" {
  organization_name = "ERUVBJC"
  account_name      = "master_data_quality.privatelink"
  user              = var.snowflake_deploy_user
  # kics-scan ignore-line - to prevent kics-interpretation of base64decode.. as hard-coded password
  private_key            = base64decode(var.snowflake_deploy_private_key_base64)
  private_key_passphrase = var.snowflake_deploy_private_key_passphrase
  role                   = "USERADMIN"
  alias                  = "useradmin"
  authenticator          = "SNOWFLAKE_JWT"
}

provider "snowflake" {
  organization_name = "ERUVBJC"
  account_name      = "master_data_quality.privatelink"
  user              = var.snowflake_deploy_user
  # kics-scan ignore-line - to prevent kics-interpretation of base64decode.. as hard-coded password
  private_key              = base64decode(var.snowflake_deploy_private_key_base64)
  private_key_passphrase   = var.snowflake_deploy_private_key_passphrase
  role                     = "SECURITYADMIN"
  alias                    = "securityadmin"
  authenticator            = "SNOWFLAKE_JWT"
  preview_features_enabled = ["snowflake_procedure_sql_resource", "snowflake_network_rule_resource", "snowflake_network_policy_attachment_resource", "snowflake_authentication_policy_resource", "snowflake_user_authentication_policy_attachment_resource"]
}
