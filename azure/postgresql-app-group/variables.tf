variable "server_fqdn" {
  description = "FQDN of the Postgres flexible server"
  type        = string
}

variable "admin_username" {
  description = "Server admin login (used to create the group + grants)"
  type        = string
}

variable "admin_password" {
  description = "Server admin password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Database the group + schemas live in"
  type        = string
}

variable "group_name" {
  description = "Name of the shared app group role (NOLOGIN)"
  type        = string
}

variable "member_roles" {
  description = "Per-app login roles that become members of the group"
  type        = list(string)
}

variable "migrator_role" {
  description = "The role that owns the schemas/tables (runs migrations). Default privileges are set FOR this role so future tables are shared with the group."
  type        = string
}

variable "schemas" {
  description = "Schemas the apps share (owned by the migrator; group gets USAGE + DML)"
  type        = list(string)
}

variable "revoke_public" {
  description = <<-EOT
    Revoke every database-level privilege from PUBLIC.

    PostgreSQL grants CONNECT to PUBLIC on every new database, so without this
    ANY role in the cluster can open a session on it. On a shared pool that is
    merely untidy -- the apps are meant to reach it. On a SILO database it
    removes the point of the tier: a tenant given "its own database" on a shared
    server is still reachable by every other app's credential.

    Measured on dev before this existed: mystoreguard_dev connected to
    silo-shared-test with no grant at all.

    Defaults false so existing callers are unchanged; silo units set it true.
  EOT
  type        = bool
  default     = false
}

variable "restricted_schemas" {
  description = <<-EOT
    Schemas whose table privileges are narrower than the full DML every other
    shared schema gets, because migrations grant them table by table.

    For each: `privileges` on the named `tables` and on every future table the
    migrator creates there; `extended` names other groups of tables with their
    own sets (e.g. the only tables the app may DELETE from). Every table appears
    in exactly one group. A table named nowhere gets nothing from this module.

    Default {} keeps every schema on the schema-wide full-DML grant.
  EOT
  type = map(object({
    privileges = list(string)
    tables     = list(string)
    extended = optional(map(object({
      tables     = list(string)
      privileges = list(string)
    })), {})
  }))
  default = {}
}
