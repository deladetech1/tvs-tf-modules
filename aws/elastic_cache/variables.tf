variable "engine_name" {
  type = string
}

variable "name" {
  type = string
}

variable "max_data_storage" {
  type = number
}

variable "max_data_storage_unit" {
  type = number
}

variable "ecpu_per_second" {
  type = number
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = list(string)
}

variable "daily_snapshot_time" {
  type = string
}

variable "description" {
  type = string
}

variable "major_engine_version" {
  type = string
}

variable "snapshot_retention_limit" {
  type = string
}