variable "server_fqdn" {
  description = "FQDN of the Postgres flexible server"
  type        = string
}

variable "admin_username" {
  description = "Server admin login (used only to create the role)"
  type        = string
}

variable "admin_password" {
  description = "Server admin password (used only to create the role)"
  type        = string
  sensitive   = true
}

variable "role_name" {
  description = "Name of the per-app login role to create"
  type        = string
}

variable "database_name" {
  description = "Database the role is granted CONNECT/CREATE on"
  type        = string
}

variable "password_length" {
  type    = number
  default = 32
}
