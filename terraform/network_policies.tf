# Account-level network policy that allows every IPv4 address. It does not restrict access,
# it only puts a formal network policy in place (Trust Center CIS 3.1). To restrict access later,
# replace 0.0.0.0/0 with trusted ranges and give the GitHub Actions deploy users their own
# user-level policy first, or the deploy locks itself out.
resource "snowflake_network_policy" "allow_all" {
  provider        = snowflake.securityadmin
  name            = "ALLOW_ALL"
  allowed_ip_list = ["0.0.0.0/0"]
  comment         = "Allows all IPv4 addresses, no restriction. Placeholder until trusted ranges are defined."
}

resource "snowflake_network_policy_attachment" "allow_all_account" {
  provider            = snowflake.securityadmin
  network_policy_name = snowflake_network_policy.allow_all.name
  set_for_account     = true
}
