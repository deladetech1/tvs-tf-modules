locals {
  # Keep the user-assigned identity attached, but optionally also enable the
  # system-assigned identity. ACA Key Vault *reference* secrets fail to resolve
  # via the user-assigned identity in this environment, so we resolve them with
  # the system-assigned identity instead (per-secret `identity = "System"`).
  identity_type = var.enable_system_assigned_identity ? "SystemAssigned, UserAssigned" : "UserAssigned"
}

resource "azurerm_container_app" "containerapp" {
  name                         = var.container_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode
  workload_profile_name        = var.workload_profile_name
  tags = var.tags
  registry {
    identity = var.user_assigned_identity_id
    server = var.container_registry_host_name
  }
  identity {
    type         = local.identity_type
    identity_ids = [var.user_assigned_identity_id]
  }

  dynamic "secret" {
    for_each = var.secrets
    content {
      name                = secret.value["name"]
      value               = lookup(secret.value, "value", null)
      key_vault_secret_id = lookup(secret.value, "key_vault_secret_id", null)
      # Per-secret identity override. Defaults to the user-assigned identity for
      # backward compatibility; pass `identity = "System"` for KV-reference
      # secrets that should resolve via the system-assigned identity.
      identity = lookup(secret.value, "identity", var.user_assigned_identity_id)
    }
  }

  template {
    container {
      name   = var.container_name
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory
      
      dynamic "env" {
        for_each = var.env_variables
        content {
          name        = env.value["name"]
          value       = lookup(env.value, "value", null)
          secret_name = lookup(env.value, "secret_name", null)
        }
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }

  ingress {
    external_enabled = var.ingress_external_enabled
    target_port      = var.ingress_target_port
    transport        = var.ingress_transport
    dynamic "traffic_weight" {
      for_each = var.traffic_weights
      content {
        label           = lookup(traffic_weight.value, "label", null)
        latest_revision = traffic_weight.value["latest_revision"]
        percentage      = traffic_weight.value["percentage"]
      }
    }
  }
}
