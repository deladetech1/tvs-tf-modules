variable "subscription_id" {
  description = "Unused by this module; accepted because every unit in the estate passes it."
  type        = string
  default     = null
}

variable "server_fqdn" {
  description = "PostgreSQL flexible server FQDN"
  type        = string
}

variable "admin_username" {
  description = "Server admin login, used to create the role and grant"
  type        = string
}

variable "admin_password" {
  description = "Server admin password"
  type        = string
  sensitive   = true
}

variable "role_name" {
  description = "The read-only login role to create"
  type        = string
}

variable "database_name" {
  description = "The ONE database this role may read. It gets CONNECT here and nowhere else."
  type        = string
}

variable "schemas" {
  description = "Schemas to grant USAGE + SELECT on"
  type        = list(string)
}

variable "owner_role" {
  description = <<-EOT
    The role that CREATES the tables -- the migrator. Default privileges are
    attached to the creator, not to the schema, so future tables are only
    readable if this names whoever makes them. Get it wrong and the grant covers
    today's tables and silently misses every one added afterwards.
  EOT
  type        = string
}

variable "password_length" {
  description = "Generated password length"
  type        = number
  default     = 32
}
