output "app_insight_id" {
  value = azurerm_application_insights.app-insight.id
}

output "app_insights_connection_string" {
  value = azurerm_application_insights.app-insight.connection_string
  sensitive = true
}