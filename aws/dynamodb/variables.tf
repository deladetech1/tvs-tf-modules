variable "table_name" {
  type = string
  description = "The name of the dynamodb table"
}

variable "hash_key_type" {
  type = string
}

variable "billing_mode" {
  description = "The dynamodb table billing_mode"
  type = string
}

variable "hash_key" {
  type = string
}

variable "tags" {
  description = "Tags to uniquely identify aws resources"
  type = map(string)
}

variable "create_global_index" {
  description = "To create a global index ?"
  type = bool
  default = false
}

variable "global_secondary_index_name" {
  description = "The global secondary index name"
  type = string
}

variable "global_secondary_index_hash_key" {
  description = "The global secondary index hash key"
  type = string
}

variable "projection_type" {
  description = "Projection type of the dynamodb table"
  type = string
}

variable "enable_ttl" {
  description = "To enable time to leave"
  type = bool
  default = false
}

variable "ttl_attribute_name" {
  type = string
}

variable "global_secondary_index_range_key" {
  type = string
  default = ""
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "dynamodb_items" {
  type    = list(map(string))
  default = []
}

variable "range_key" {
  type = string
  default = ""
}