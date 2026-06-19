# Shared-access group for per-app DB users. Apps each have their own login role
# (created by the postgresql-role module) but share one database whose tables are
# owned by the migrator role. This module wires the shared access:
#   * a NOLOGIN group role,
#   * each app login role made a member of the group,
#   * the migrator granted CONNECT/CREATE on the database,
#   * the shared schemas pre-created (owned by the migrator; idempotent with the
#     migrator's own CREATE SCHEMA IF NOT EXISTS),
#   * the group granted USAGE + DML on those schemas (existing objects), and
#   * ALTER DEFAULT PRIVILEGES FOR the migrator so FUTURE tables/sequences it
#     creates are automatically granted to the group.
# Net effect: every app authenticates as itself but gets full CRUD on the shared
# data, while DDL/migrations stay with the migrator.

# NOLOGIN group role.
resource "postgresql_role" "group" {
  name  = var.group_name
  login = false
}

# The applying admin must be a member of the migrator role to manage its default
# privileges (PG 16+ grants the creator membership automatically; this is a
# belt-and-suspenders no-op if already a member).
resource "postgresql_grant_role" "admin_in_migrator" {
  role       = var.admin_username
  grant_role = var.migrator_role
}

# Migrator can connect + create schemas in this database.
resource "postgresql_grant" "migrator_db" {
  database    = var.database_name
  role        = var.migrator_role
  object_type = "database"
  privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
}

# Group can connect to the database.
resource "postgresql_grant" "group_db" {
  database    = var.database_name
  role        = postgresql_role.group.name
  object_type = "database"
  privileges  = ["CONNECT", "TEMPORARY"]
}

# Shared schemas, owned by the migrator.
resource "postgresql_schema" "shared" {
  for_each   = toset(var.schemas)
  name       = each.value
  database   = var.database_name
  owner      = var.migrator_role
  depends_on = [postgresql_grant_role.admin_in_migrator, postgresql_grant.migrator_db]
}

# Group: USAGE on each schema.
resource "postgresql_grant" "schema_usage" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.group.name
  schema      = each.value
  object_type = "schema"
  privileges  = ["USAGE"]
  depends_on  = [postgresql_schema.shared]
}

# Group: DML on existing tables in each schema.
resource "postgresql_grant" "tables" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.group.name
  schema      = each.value
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
  depends_on  = [postgresql_schema.shared]
}

# Group: usage on existing sequences in each schema.
resource "postgresql_grant" "sequences" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.group.name
  schema      = each.value
  object_type = "sequence"
  privileges  = ["USAGE", "SELECT", "UPDATE"]
  depends_on  = [postgresql_schema.shared]
}

# FUTURE tables the migrator creates -> auto-granted (DML) to the group.
resource "postgresql_default_privileges" "tables" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  owner       = var.migrator_role
  role        = postgresql_role.group.name
  schema      = each.value
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
  depends_on  = [postgresql_grant_role.admin_in_migrator, postgresql_schema.shared]
}

# FUTURE sequences the migrator creates -> usage to the group.
resource "postgresql_default_privileges" "sequences" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  owner       = var.migrator_role
  role        = postgresql_role.group.name
  schema      = each.value
  object_type = "sequence"
  privileges  = ["USAGE", "SELECT", "UPDATE"]
  depends_on  = [postgresql_grant_role.admin_in_migrator, postgresql_schema.shared]
}

# Each app login role joins the group (inherits the shared CRUD).
resource "postgresql_grant_role" "members" {
  for_each   = toset(var.member_roles)
  role       = each.value
  grant_role = postgresql_role.group.name
}
