# Connects with the ADMIN login to create the role and grant it. Needs network
# reachability to <fqdn>:5432 at plan/apply time.
provider "postgresql" {
  host            = var.server_fqdn
  port            = 5432
  database        = var.database_name
  username        = var.admin_username
  password        = var.admin_password
  sslmode         = "require"
  superuser       = false
  connect_timeout = 15
}
