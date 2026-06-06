variable "resource_group_name" {
  type        = string
}

variable "container_app_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "container_app_environment_id" {
  type = string
}

variable "workload_profile_name" {
  type = string
}

variable "revision_mode" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = string
}

variable "min_replicas" {
  type = number
}

variable "max_replicas" {
  type = number
}

variable "ingress_external_enabled" {
  type = bool
  default = true
}

variable "ingress_target_port" {
  type = number
}

variable "ingress_transport" {
  type = string
}

variable "user_assigned_identity_id" {
  type = string
}

variable "enable_system_assigned_identity" {
  type        = bool
  default     = false
  description = "Also attach a system-assigned identity (kept alongside the user-assigned one). Used to resolve Key Vault reference secrets, which fail via the user-assigned identity in ACA."
}

variable "secrets" {
  type = list(object({
    name                = string
    value               = optional(string)
    key_vault_secret_id = optional(string)
    # Identity used to resolve a Key Vault reference secret. Pass "System" to use
    # the system-assigned identity; omit to default to the user-assigned identity.
    identity            = optional(string)
  }))
}

variable "env_variables" {
  type = list(object({
    name        = string
    value       = optional(string)
    secret_name = optional(string)
  }))
}

variable "traffic_weights" {
  type = list(object({
    label           = optional(string)
    latest_revision = bool
    percentage      = number
  }))
}

variable "container_registry_host_name" {
  type = string
}

variable "subscription_id" {
  type = string
}