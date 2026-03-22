module "snowflake_shared_databases" {
  source = "github.com/inovex/snowform_import_listing.git?ref=0.0.1"

  providers = {
    snowflake.sysadmin = snowflake.sysadmin
  }

  snowflake_shares = [
    {
      database_name = "CUSTOMER_LEADS_IMPORTED_DB"
      share_name    = "ERUVBJC.INOVEX_PARTNER.CUSTOMER_LEADS_SHARE"
    },
    {
      database_name = "WEB_UI_IMPORTED_DB"
      share_name    = "ERUVBJC.INOVEX_PARTNER.WEB_UI_SHARE"
    },
  ]

  account_roles = [
    "SYSADMIN", # todo replace with real consumer or developer role
  ]
}