resource "aws_iam_policy" "iam_policy" {
  name        = var.policy_name
  description = var.description

  policy = var.policy
  tags = var.tags
}