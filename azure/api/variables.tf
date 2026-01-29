
variable "resource_group_name" {
  type        = string
}

variable "api_name" {
  type = string
}

variable "api_management_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "protocols" {
  type = list(string)
}

variable "path" {
  type = string
}

variable "service_url" {
  type = string
}

variable "revision" {
  type = string
  default = "1"
}