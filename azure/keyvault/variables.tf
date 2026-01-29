variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "resource_group_location" {
  type = string
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "sku_name" {
  description = "SKU of the Key Vault"
  type        = string
  default     = "standard"
}

variable "purge_protection_enabled" {
  description = "Enable Purge Protection for the Key Vault"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted Key Vault"
  type        = number
  default     = 7
}

variable "default_action" {
  description = "Default action for network ACLs"
  type        = string
  default     = "Allow"
}

variable "bypass" {
  description = "Specifies bypass behavior for Key Vault network rules"
  type        = string
  default     = "AzureServices"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "enable_rbac_authorization" {
  type = bool
  default = true
}

variable "subscription_id" {
  type = string
}