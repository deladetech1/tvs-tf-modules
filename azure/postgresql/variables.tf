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

variable "allow_azure_services" {
  description = "Add a 0.0.0.0 firewall rule allowing access from Azure services (needed so Azure-hosted runners can create per-app DB roles)."
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "Explicit firewall rules: name => { start_ip, end_ip }."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}