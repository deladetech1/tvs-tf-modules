output "username" {
  value = postgresql_role.readonly.name
}

output "password" {
  value     = random_password.readonly.result
  sensitive = true
}
