variable "resource_group_name" {
  type        = string
}

variable "resource_group_location" {
  type        = string
}

variable "postgresql_server_name" {
  type        = string
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
}

variable "postgresql_version" {
  type        = string
}

variable "postgresql_admin_username" {
  type        = string
  default     = "adminuser"
}

variable "postgresql_admin_password" {
  type        = string
  sensitive   = true
}

variable "postgresql_sku_name" {
  type        = string
}

variable "postgresql_storage_mb" {
  type        = number
  default     = 5432
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "storage_tier" {
  type = string
}

variable "postgresql_zone" {
  type = string
}

variable "auto_grow_enabled" {
  type = bool
}

variable "subscription_id" {
  type = string
}