variable "cae_name" {
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

variable "log_analytics_workspace_id" {
  type = string
}

variable "workload_profile_name" {
  type = string
}

variable "workload_profile_type" {
  type = string
}

variable "subscription_id" {
  type = string
}