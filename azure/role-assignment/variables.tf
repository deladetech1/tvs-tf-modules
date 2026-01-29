variable "role_assignments" {
  type = map(any)
  default = {}
}

variable "managed_identity_principal_id" {
  type = string
}

variable "subscription_id" {
  type = string
}