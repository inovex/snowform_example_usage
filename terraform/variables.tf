variable "snowflake_deploy_user" {
  type        = string
  description = "CI/CD variable TF_VAR_snowflake_deploy_user, name of the deployment user"
}

variable "snowflake_deploy_private_key_base64" {
  type        = string
  description = "CI/CD variable TF_VAR_snowflake_deploy_private_key_base64"
  sensitive   = true
}

variable "snowflake_deploy_private_key_passphrase" {
  type        = string
  description = "CI/CD variable TF_VAR_snowflake_deploy_private_key_passphrase"
  sensitive   = true
}
