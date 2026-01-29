variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "resource_group_location" {
  description = "Azure location for resources"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account (must be globally unique)"
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication strategy for the storage account (LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}


variable "subscription_id" {
  type = string
}