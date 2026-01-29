variable "dynamodb_items" {
  type    = list(map(string))
  default = []
}

variable "hash_key" {
  type = string
}

variable "dynamodb_name" {
  type = string
}