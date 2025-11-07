variable "SNOWFLAKE_DEPLOY_USER" {
  type        = string
  description = "CI/CD variable TF_VAR_snowflake_deploy_user, name of the deployment user"
}

variable "SNOWFLAKE_DEPLOY_PRIVATE_KEY_BASE64" {
  type        = string
  description = "CI/CD variable TF_VAR_SNOWFLAKE_DEPLOY_PRIVATE_KEY_BASE64"
  sensitive   = true
}

variable "SNOWFLAKE_DEPLOY_PRIVATE_KEY_PASSPHRASE" {
  type        = string
  description = "CI/CD variable TF_VAR_SNOWFLAKE_DEPLOY_PRIVATE_KEY_PASSPHRASE"
  sensitive   = true
}
