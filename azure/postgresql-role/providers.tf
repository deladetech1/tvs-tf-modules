# Connects to the Postgres flexible server with the ADMIN login to create the
# per-app login role. Requires network reachability to <fqdn>:5432 at plan/apply
# time (Azure Postgres needs a firewall rule — see the server module's
# allow_azure_services / allowed_ip_ranges).
provider "postgresql" {
  host            = var.server_fqdn
  port            = 5432
  database        = "postgres"
  username        = var.admin_username
  password        = var.admin_password
  sslmode         = "require"
  superuser       = false
  connect_timeout = 15
}
