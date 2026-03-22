import {
  to = snowflake_database.common_db
  id = "COMMON"
}

import {
  to = snowflake_schema.common_common_schema
  id = "\"COMMON\".\"COMMON\""
}

import {
  to = module.snowflake_shared_databases.snowflake_shared_database.this["CUSTOMER_LEADS_IMPORTED_DB"]
  id = "CUSTOMER_LEADS_IMPORTED_DB"
}

import {
  to = module.snowflake_shared_databases.snowflake_shared_database.this["WEB_UI_IMPORTED_DB"]
  id = "WEB_UI_IMPORTED_DB"
}

# The below imports are for the database grants. 
# Identifying string format for grants can vary slightly by provider version.
import {
  to = module.snowflake_shared_databases.snowflake_grant_privileges_to_account_role.database_access["CUSTOMER_LEADS_IMPORTED_DB_SYSADMIN"]
  id = "SYSADMIN|IMPORTED PRIVILEGES|false|DATABASE|CUSTOMER_LEADS_IMPORTED_DB|false|false"
}

import {
  to = module.snowflake_shared_databases.snowflake_grant_privileges_to_account_role.database_access["WEB_UI_IMPORTED_DB_SYSADMIN"]
  id = "SYSADMIN|IMPORTED PRIVILEGES|false|DATABASE|WEB_UI_IMPORTED_DB|false|false"
}

# Note: snowflake_execute cannot be imported as it is a query execution block rather than a permanent resource.
# OpenTofu will comfortably "re-run" it.
