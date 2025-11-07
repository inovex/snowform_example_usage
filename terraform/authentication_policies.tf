# locals {
#   deploy_user_list = toset([
#     "snowflake_deploy_staging",
#     "snowflake_deploy_prod",
#   ])
# }

# # This authentication policy allows only keypair and is used for service users.
# resource "snowflake_authentication_policy" "allow_only_keypair" {
#   provider               = snowflake.securityadmin
#   database               = snowflake_database.common_db.name
#   schema                 = snowflake_schema.common_common_schema.name
#   name                   = "ALLOW_ONLY_KEYPAIR"
#   authentication_methods = ["KEYPAIR"]
#   comment                = "Allow only authentication by keypair"
#   depends_on = [
#     snowflake_database.common_db,
#     snowflake_schema.common_common_schema,
#   ]
# }

# # Attach keypair auth policy to all deploy users defined in the local variable
# resource "snowflake_user_authentication_policy_attachment" "attach_allow_only_keypair_to_service_users" {
#   provider                   = snowflake.securityadmin
#   for_each                   = local.deploy_user_list
#   authentication_policy_name = snowflake_authentication_policy.allow_only_keypair.fully_qualified_name
#   user_name                  = each.value
#   depends_on = [
#     snowflake_authentication_policy.allow_only_keypair,
#   ]
# }
