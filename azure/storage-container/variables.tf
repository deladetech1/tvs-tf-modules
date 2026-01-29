variable "storage_account_name" {
  type        = string
}

variable "container_name" {
  type        = string
}

variable "container_access_type" {
  type        = string
  default     = "private"
}

variable "subscription_id" {
  type = string
}