# Connects to the Postgres flexible server with the ADMIN login to manage the
# group role, schemas, grants and default privileges. Requires network
# reachability to <fqdn>:5432 at plan/apply time (see the server module's
# allow_azure_services / allowed_ip_ranges).
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
