# A read-only login for ONE database, meant to be handed to the tenant who owns
# it.
#
# This is the credential a silo customer gets when they ask to see their own
# data. It is deliberately not the app's role and not the migrator's: those can
# write and create, and a credential that leaves our control should be able to do
# neither.
#
# What it can do: connect to one database, look at the listed schemas, SELECT.
# What it cannot do: write anything, create anything, take a temp table, reach
# any other database on the server, or inherit from tvs_app_<env>.

# URL-safe so it can be embedded in a connection string without encoding -- the
# same reason the app role module does it.
resource "random_password" "readonly" {
  length  = var.password_length
  special = false
}

resource "postgresql_role" "readonly" {
  name     = var.role_name
  login    = true
  password = random_password.readonly.result

  # Said explicitly rather than left to the provider's defaults, because this is
  # the one role whose password goes to somebody outside.
  create_database           = false
  create_role               = false
  superuser                 = false
  replication               = false
  bypass_row_level_security = false

  # No `roles`: this role is a member of nothing. In particular not
  # tvs_app_<env>, which carries DML on every shared schema -- joining it would
  # quietly turn this into a read-write credential.
  lifecycle {
    ignore_changes = [roles]
  }
}

# CONNECT only. No CREATE (it could add schemas and objects), no TEMPORARY (it
# could fill the disk with temp tables).
resource "postgresql_grant" "database_connect" {
  database    = var.database_name
  role        = postgresql_role.readonly.name
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "schema_usage" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.readonly.name
  schema      = each.value
  object_type = "schema"
  privileges  = ["USAGE"]
}

# Tables that exist now.
resource "postgresql_grant" "tables_select" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.readonly.name
  schema      = each.value
  object_type = "table"
  privileges  = ["SELECT"]
}

# Sequences, SELECT only -- enough to read a current value, not to advance one.
resource "postgresql_grant" "sequences_select" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  role        = postgresql_role.readonly.name
  schema      = each.value
  object_type = "sequence"
  privileges  = ["SELECT"]
}

# Tables added LATER. Without this the grant above covers only what existed at
# apply time, and the next migration's tables are invisible -- which looks like
# missing data rather than a missing grant, and is the failure somebody debugs
# for an afternoon.
resource "postgresql_default_privileges" "tables_select" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  owner       = var.owner_role
  role        = postgresql_role.readonly.name
  schema      = each.value
  object_type = "table"
  privileges  = ["SELECT"]
}

resource "postgresql_default_privileges" "sequences_select" {
  for_each    = toset(var.schemas)
  database    = var.database_name
  owner       = var.owner_role
  role        = postgresql_role.readonly.name
  schema      = each.value
  object_type = "sequence"
  privileges  = ["SELECT"]
}
