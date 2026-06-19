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
