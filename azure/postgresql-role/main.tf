# Random, URL-safe password (no special chars -> safe to embed in a connection
# URL without urlencoding).
resource "random_password" "role" {
  length  = var.password_length
  special = false
}

# Per-app login role.
resource "postgresql_role" "app" {
  name     = var.role_name
  login    = true
  password = random_password.role.result
}

# Least-privilege: connect to the app's database and create its own schemas
# (apps run their own migrations and own what they create).
resource "postgresql_grant" "database" {
  database    = var.database_name
  role        = postgresql_role.app.name
  object_type = "database"
  privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
}
