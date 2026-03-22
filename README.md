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

## ⚠️ Important Note: Terraform State Expiration

This repository uses GitHub Actions Artifacts to store the encrypted Terraform state file. By default, GitHub imposes a retention limit of 90 days on workflow artifacts. **If no pipeline successfully runs and uploads a new state within 90 days, the Terraform state artifact will expire and be permanently deleted by GitHub.**

When this happens, the underlying Terraform state is completely destroyed. OpenTofu/Terraform will view this as an empty state, and any subsequent pipeline runs will attempt to recreate all your Snowflake resources from scratch (which can cause failures or duplicate resources).

To safely recover from an expired state:
1. You must completely recreate the state utilizing Terraform/OpenTofu `import {}` blocks in your configurations.
2. The `import {}` blocks will map your exact live Snowflake configuration components back into memory.
3. Pushing these changes will allow the pipeline to execute `tofu apply`, which will absorb your existing resources, reconstruct a fresh state file, and upload a brand new artifact—effectively restarting the 90-day timer.

Or if there is nothing important in the test account, just delete all the resources and recreate them with terraform.

*Otherwise, to prevent the state from being lost, ensure you run the pipeline to update the state at least once every 90 days.*
