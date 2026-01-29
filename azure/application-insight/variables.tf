variable "workspace_id" {
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

variable "insight_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "application_type" {
  type = string
  default = "web"
}