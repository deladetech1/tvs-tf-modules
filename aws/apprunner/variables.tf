variable "auto_deployments_enabled" {
  type = bool
  default = true
}

variable "appprunner_service_role_arn" {
  type = string
}

variable "appprunner_instance_role_arn" {
  type = string
}

variable "service_name" {
  type = string
}

variable "port_number" {
  type = string
}

variable "runtime_environment_variables" {
  type = map(any)
}

variable "image_url" {
  type = string
}
