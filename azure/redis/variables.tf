variable "redis_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "capacity" {
  type = number
}

variable "redis_family" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "non_ssl_port_enabled" {
  type = bool
}

variable "minimum_tls_version" {
  type = string
}

variable "public_network_access_enabled" {
  type = bool
  default = false
}

variable "subscription_id" {
  type = string
}