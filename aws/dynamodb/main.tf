
resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key

  # Conditionally set the range key only if it's defined
  range_key = var.range_key != "" ? var.range_key : null

  # Dynamically generate attributes
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Conditionally create TTL configuration
  dynamic "ttl" {
    for_each = var.enable_ttl ? [1] : []  # Only include TTL if enabled
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = true
    }
  }

 # Conditionally create the Global Secondary Index (GSI)
  dynamic "global_secondary_index" {
    for_each = var.create_global_index ? [1] : []
    content {
      name               = var.global_secondary_index_name
      hash_key           = var.global_secondary_index_hash_key
      range_key          = var.global_secondary_index_range_key
      projection_type    = var.projection_type
    }
  }

  tags = var.tags
}