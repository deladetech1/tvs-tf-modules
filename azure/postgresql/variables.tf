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
variable "maintenance_window" {
  description = "Custom maintenance window (UTC): day_of_week 0=Sunday..6, start_hour 0-23, start_minute 0-59. null = Azure's own schedule (any time)."
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = optional(number, 0)
  })
  default = null

  validation {
    condition = var.maintenance_window == null ? true : (
      var.maintenance_window.day_of_week >= 0 && var.maintenance_window.day_of_week <= 6 &&
      var.maintenance_window.start_hour >= 0 && var.maintenance_window.start_hour <= 23 &&
      var.maintenance_window.start_minute >= 0 && var.maintenance_window.start_minute <= 59
    )
    error_message = "maintenance_window: day_of_week 0-6, start_hour 0-23, start_minute 0-59."
  }
}

variable "high_availability_mode" {
  description = "null (no standby), \"ZoneRedundant\" or \"SameZone\". Not available on Burstable (B_) SKUs."
  type        = string
  default     = null

  validation {
    condition     = var.high_availability_mode == null ? true : contains(["ZoneRedundant", "SameZone"], var.high_availability_mode)
    error_message = "high_availability_mode must be null, ZoneRedundant or SameZone."
  }
}

variable "standby_availability_zone" {
  description = "Standby zone for ZoneRedundant HA (must differ from postgresql_zone)."
  type        = string
  default     = "2"
}
