variable "bucket_name" {
  type = string

}
variable "enable_versioning" {
  type    = string
  default = "Enabled"
}

variable "tags" {
  type = map(string)
}

variable "cloudfront_default_certificate" {
  type = bool
}

variable "price_class" {
  type = string
}
