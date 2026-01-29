variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "service_plan_name" {
  type = string
}

variable "sku_name" {
  type = string
  default = "FC1"
}

variable "os_type" {
  type = string
  default = "Linux"
}

variable "app_flex_consumption_name" {
  type = string
}

variable "storage_container_type" {
  type = string
  default = "blobContainer"
}

# During function app deployment, which auth type should be used to access storage account
variable "storage_authentication_type" {
  type = string
  default = null
}

variable "identity_type" {
  type = string
  default = "UserAssigned"
}

variable "runtime_name" {
  type = string
  default = "python"
}

variable "runtime_version" {
  type = string
  default = "3.12"
}

variable "instance_memory_in_mb" {
  type = number
  default = 2048
}

variable "maximum_instance_count" {
  type = number
  default = 50
}

variable "identity_ids" {
  type = list(string)
}

variable "app_settings" {
  type = map(string)
}

variable "app_insights_connection_string" {
  type = string 
  sensitive = true
}

variable "storage_container_endpoint" {
  type = string
}

variable "storage_user_assigned_identity_id" {
  type = string
  default = null
}

variable "storage_access_key" {
  type = string
  default = null
}

variable "tags" {
  type        = map(string)
}
