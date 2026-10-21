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

locals {
  full_dml = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]

  # Each extra table group of a restricted schema, keyed "<schema>/<group>".
  restricted_extended = merge([for s, r in var.restricted_schemas : {
    for g, e in r.extended : "${s}/${g}" => merge(e, { schema = s })
  }]...)
}

# Group: DML on existing tables in each schema.
#
# A schema in var.restricted_schemas is granted on the NAMED tables only, with its
# own privilege set, instead of on every table in the schema. Same address either
# way, so restricting a schema replaces this one grant in place (destroy, then
# create) rather than racing a separate resource.
resource "postgresql_grant" "tables" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.group.name
  schema      = each.value
  object_type = "table"
  objects     = contains(keys(var.restricted_schemas), each.value) ? var.restricted_schemas[each.value].tables : []
  privileges  = contains(keys(var.restricted_schemas), each.value) ? var.restricted_schemas[each.value].privileges : local.full_dml
  depends_on  = [postgresql_schema.shared]
}

# Restricted schemas: the tables that get a different privilege set from the
# schema's base one (e.g. the only tables an app may DELETE from). Disjoint from
# the base table list -- two grants on one table would each read the other's
# privileges back as drift.
#
# After postgresql_grant.tables: replacing a schema-wide grant revokes ALL on
# every table in the schema, which would otherwise wipe these.
resource "postgresql_grant" "restricted_tables" {
  for_each    = local.restricted_extended
  database    = var.database_name
  role        = postgresql_role.group.name
  schema      = each.value.schema
  object_type = "table"
  objects     = each.value.tables
  privileges  = each.value.privileges
  depends_on  = [postgresql_grant.tables]
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
  # A restricted schema's future tables get its base set, never the full DML.
  privileges = contains(keys(var.restricted_schemas), each.value) ? var.restricted_schemas[each.value].privileges : local.full_dml
  depends_on = [postgresql_grant_role.admin_in_migrator, postgresql_schema.shared]
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

# Strip PUBLIC's implicit CONNECT. An empty privileges list is how the provider
# expresses a revoke.
#
# Ordering matters: this must run AFTER the migrator and group grants above, or
# the revoke would take their CONNECT with it -- PUBLIC is not a role you remove
# from, it is a default you override, and the explicit grants have to be in place
# first for anything to still be able to reach the database.
resource "postgresql_grant" "revoke_public_database" {
  count = var.revoke_public ? 1 : 0

  database    = var.database_name
  role        = "public"
  object_type = "database"
  privileges  = []

  depends_on = [
    postgresql_grant.migrator_db,
    postgresql_grant.group_db,
  ]
}
