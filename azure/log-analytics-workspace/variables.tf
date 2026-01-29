variable "log_analytics_workspace_name" {
  type = string
}

variable "resource_group_name" {
  type        = string
}

variable "resource_group_location" {
  type        = string
}

variable "tags" {
  type        = map(string)
}

variable "retention_in_days" {
  type = number
}

variable "sku" {
  type = string
}

variable "subscription_id" {
  type = string
}