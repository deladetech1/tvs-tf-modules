locals {
  # Two supported identity modes:
  #   * user-assigned (optionally + system-assigned) — pass user_assigned_identity_id
  #   * system-assigned-only — leave user_assigned_identity_id null
  # ACA Key Vault *reference* secrets resolve via the system-assigned identity
  # (per-secret `identity = "System"`); ACR pulls use whichever identity is set.
  use_uami = var.user_assigned_identity_id != null

  identity_type = local.use_uami ? (
    var.enable_system_assigned_identity ? "SystemAssigned, UserAssigned" : "UserAssigned"
  ) : "SystemAssigned"
  identity_ids = local.use_uami ? [var.user_assigned_identity_id] : []

  # Registry pull identity: a resource id for a UAMI, or the literal "system"
  # for the system-assigned identity.
  registry_identity = local.use_uami ? var.user_assigned_identity_id : "System"

  # Default identity for KV-reference secrets when a secret doesn't set its own.
  default_secret_identity = local.use_uami ? var.user_assigned_identity_id : "System"
}

resource "azurerm_container_app" "containerapp" {
  name                         = var.container_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode
  workload_profile_name        = var.workload_profile_name
  tags = var.tags
  registry {
    identity = local.registry_identity
    server = var.container_registry_host_name
  }
  identity {
    type         = local.identity_type
    identity_ids = local.identity_ids
  }

  dynamic "secret" {
    for_each = var.secrets
    content {
      name                = secret.value["name"]
      value               = lookup(secret.value, "value", null)
      key_vault_secret_id = lookup(secret.value, "key_vault_secret_id", null)
      # Per-secret identity override. Defaults to the user-assigned identity when
      # present, otherwise the system-assigned identity; pass `identity = "System"`
      # explicitly for KV-reference secrets in mixed mode.
      identity = lookup(secret.value, "identity", local.default_secret_identity)
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
