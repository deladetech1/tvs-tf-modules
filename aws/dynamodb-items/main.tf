# resource "aws_dynamodb_table_item" "items" {
#   for_each = { for idx, item in var.dynamodb_items : idx => item }

#   table_name = var.dynamodb_name
#   hash_key   = each.value[var.hash_key]

#   item = jsonencode(each.value)
# }

resource "aws_dynamodb_table_item" "items" {
  for_each = { for idx, item in var.dynamodb_items : idx => item }

  table_name = var.dynamodb_name
  hash_key   = each.value[var.hash_key]  # Use `each.value` instead of `item.value`

  item = jsonencode(each.value)  # Use `each.value`
}
