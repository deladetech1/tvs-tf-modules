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

  # Group membership is owned by the postgresql-app-group module, which adds
  # every app role to tvs_app_<env> for cross-schema access. This resource does
  # not set `roles`, so without this the provider reads that live membership as
  # drift and REVOKES it on the next apply — the app keeps authenticating but
  # loses the shared schemas, surfacing as "permission denied for schema
  # core_platform" on the first query. The two units then fight: the role unit
  # revokes, the group unit re-grants.
  lifecycle {
    ignore_changes = [roles]
  }
}

# Least-privilege: connect to the app's database and create its own schemas
# (apps run their own migrations and own what they create).
resource "postgresql_grant" "database" {
  database    = var.database_name
  role        = postgresql_role.app.name
  object_type = "database"
  privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
}
