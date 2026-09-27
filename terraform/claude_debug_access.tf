# Read-only access for Claude Code to debug the deployed resources through the
# Snowflake-managed MCP server. See "Claude Code Debug Access (MCP)" in README.md.

locals {
  claude_debug_mcp_server = "${snowflake_database.common_db.name}.${snowflake_schema.common_common_schema.name}.CLAUDE_DEBUG_MCP"
}

resource "snowflake_account_role" "claude_debug" {
  provider = snowflake.useradmin
  name     = "CLAUDE_DEBUG_ROLE"
  comment  = "Read-only role for debugging with Claude Code through the MCP server"
}

resource "snowflake_grant_account_role" "claude_debug_to_sysadmin" {
  provider         = snowflake.securityadmin
  role_name        = snowflake_account_role.claude_debug.name
  parent_role_name = "SYSADMIN"
}

# Read the deployed data: COMMON.COMMON and the logical import layer views
resource "snowflake_grant_account_role" "common_r_to_claude_debug" {
  provider         = snowflake.securityadmin
  role_name        = module.access_roles.r["COMMON"].name
  parent_role_name = snowflake_account_role.claude_debug.name
}

resource "snowflake_grant_account_role" "consumer_to_claude_debug" {
  provider         = snowflake.securityadmin
  role_name        = snowflake_account_role.consumer.name
  parent_role_name = snowflake_account_role.claude_debug.name
}

# MONITOR shows the query history of the warehouse, including the deploy user's queries
resource "snowflake_grant_privileges_to_account_role" "claude_debug_warehouse" {
  provider          = snowflake.sysadmin
  privileges        = ["MONITOR", "USAGE"]
  account_role_name = snowflake_account_role.claude_debug.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.xs_wh.name
  }
}

resource "snowflake_service_user" "claude_debug" {
  provider                       = snowflake.useradmin
  name                           = "CLAUDE_DEBUG_USER"
  default_role                   = snowflake_account_role.claude_debug.name
  default_warehouse              = snowflake_warehouse.xs_wh.name
  default_secondary_roles_option = "NONE"
  comment                        = "Service user for Claude Code (MCP). Authenticates only with a PAT restricted to CLAUDE_DEBUG_ROLE."
}

resource "snowflake_grant_account_role" "claude_debug_to_user" {
  provider  = snowflake.securityadmin
  role_name = snowflake_account_role.claude_debug.name
  user_name = snowflake_service_user.claude_debug.name
}

# SECURITYADMIN creates the authentication policy in COMMON.COMMON, which SYSADMIN owns
resource "snowflake_grant_privileges_to_account_role" "securityadmin_common_db_usage" {
  provider          = snowflake.sysadmin
  privileges        = ["USAGE"]
  account_role_name = "SECURITYADMIN"
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.common_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "securityadmin_common_schema_auth_policy" {
  provider          = snowflake.sysadmin
  privileges        = ["CREATE AUTHENTICATION POLICY", "USAGE"]
  account_role_name = "SECURITYADMIN"
  on_schema {
    schema_name = "\"${snowflake_database.common_db.name}\".\"${snowflake_schema.common_common_schema.name}\""
  }
}

# PAT is the only allowed login method. A PAT normally requires a network policy on the user;
# ENFORCED_NOT_REQUIRED allows it from any IP (a network policy is still enforced if one is added).
resource "snowflake_authentication_policy" "claude_debug_pat_only" {
  provider               = snowflake.securityadmin
  database               = snowflake_database.common_db.name
  schema                 = snowflake_schema.common_common_schema.name
  name                   = "CLAUDE_DEBUG_PAT_ONLY"
  authentication_methods = ["PROGRAMMATIC_ACCESS_TOKEN"]
  comment                = "Claude Code debug user: PAT only, max 90 days, no network policy required"
  pat_policy {
    default_expiry_in_days    = 90
    max_expiry_in_days        = 90
    network_policy_evaluation = "ENFORCED_NOT_REQUIRED"
  }
  depends_on = [
    snowflake_grant_privileges_to_account_role.securityadmin_common_db_usage,
    snowflake_grant_privileges_to_account_role.securityadmin_common_schema_auth_policy,
  ]
}

# Reading the attachment back queries the policy references, which needs a warehouse
resource "snowflake_grant_privileges_to_account_role" "securityadmin_warehouse_usage" {
  provider          = snowflake.sysadmin
  privileges        = ["USAGE"]
  account_role_name = "SECURITYADMIN"
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.xs_wh.name
  }
}

resource "snowflake_user_authentication_policy_attachment" "claude_debug_pat_only" {
  provider                   = snowflake.securityadmin
  authentication_policy_name = snowflake_authentication_policy.claude_debug_pat_only.fully_qualified_name
  user_name                  = snowflake_service_user.claude_debug.name
  depends_on                 = [snowflake_grant_privileges_to_account_role.securityadmin_warehouse_usage]
}

# The provider has no MCP server resource yet, so plain SQL is used
resource "snowflake_execute" "claude_debug_mcp_server" {
  provider = snowflake.sysadmin
  execute  = <<-SQL
    CREATE OR REPLACE MCP SERVER ${local.claude_debug_mcp_server} FROM SPECIFICATION $$
    tools:
      - name: "sql_readonly"
        title: "Read-only SQL"
        type: "SYSTEM_EXECUTE_SQL"
        description: "Runs read-only SELECT queries in the SnowForm example account as CLAUDE_DEBUG_ROLE, for debugging the deployed resources."
        config:
          read_only: true
          query_timeout: 120
          warehouse: "${snowflake_warehouse.xs_wh.name}"
    $$
  SQL
  revert   = "DROP MCP SERVER IF EXISTS ${local.claude_debug_mcp_server}"
}

resource "snowflake_execute" "grant_claude_debug_mcp_usage" {
  provider   = snowflake.sysadmin
  execute    = "GRANT USAGE ON MCP SERVER ${local.claude_debug_mcp_server} TO ROLE ${snowflake_account_role.claude_debug.name}"
  revert     = "REVOKE USAGE ON MCP SERVER ${local.claude_debug_mcp_server} FROM ROLE ${snowflake_account_role.claude_debug.name}"
  depends_on = [snowflake_execute.claude_debug_mcp_server]

  lifecycle {
    # CREATE OR REPLACE drops the grant, so grant again whenever the server is recreated
    replace_triggered_by = [snowflake_execute.claude_debug_mcp_server]
  }
}
