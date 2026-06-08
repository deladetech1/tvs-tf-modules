output "username" {
  value = postgresql_role.app.name
}

output "password" {
  value     = random_password.role.result
  sensitive = true
}
