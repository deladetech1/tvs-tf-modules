
variable "resource_group_name" {
  type        = string
}

variable "resource_group_location" {
  type        = string
}

variable "acr_name" {
  type        = string
}

variable "acr_sku" {
  type        = string
}

variable "acr_admin_enabled" {
  type        = bool
}


variable "tags" {
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  type = bool
  default = false
}

variable "subscription_id" {
  type = string
}