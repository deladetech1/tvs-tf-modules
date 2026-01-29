resource "aws_secretsmanager_secret" "secrets-manager" {
  name = var.secrets_name
  tags = var.tags
}