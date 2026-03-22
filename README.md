# snowform_example_usage
Example Snowflake Account setup using tofu demonstratig usage of SnowForm Modules

## Snowflake Account Overview

This repository configures a Snowflake account (`INOVEX_TF_MODULES` in organization `ERUVBJC`) using Terraform/OpenTofu. The configured resources include:

**Databases & Schemas:**
- `COMMON` database with a `COMMON` schema (configured with managed access and non-transient).

**Imported Data Shares:**
- `CUSTOMER_LEADS_IMPORTED_DB` (from share `ERUVBJC.INOVEX_PARTNER.CUSTOMER_LEADS_SHARE`)
- `WEB_UI_IMPORTED_DB` (from share `ERUVBJC.INOVEX_PARTNER.WEB_UI_SHARE`)
These shares are mapped to local databases and made available to the `SYSADMIN` role using the `snowform_import_listing` module.

**Roles & Access Control:**
- Access roles are dynamically generated for the `COMMON` database and schema using the `snowform_access_roles` module.
- Specific privileges (e.g., `CREATE NETWORK RULE`) are explicitly granted to `SECURITYADMIN` on the `COMMON` schema.
- The setup utilizes dedicated providers for `SYSADMIN`, `USERADMIN`, and `SECURITYADMIN` roles, authenticating via Key-Pair (JWT).

