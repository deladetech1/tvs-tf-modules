
include "root" {
  path = find_in_parent_folders("common.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "deep"
}

include "main_env" {
  path = find_in_parent_folders("main_env.hcl")
  expose         = true
  merge_strategy = "deep"
}

terraform {
  source = "../../../../../../terraform/modules/role-assignment"

  extra_arguments "args" {
    commands = [
      "init",
      "plan",
      "apply",
      "destroy",
      "refresh"
    ]
  }
}

dependency "func"{
  config_path = "../func"
}

dependency "application_data_storage"{
  config_path = "../../storage-account/storage/application-data-storage"
}

dependency "function_metadata"{
  config_path = "../../storage-account/storage/function-metadata"
}

dependency "keyvault_id"{
  config_path = "../../keyvault/vault"
}

dependency "log_analytics"{
  config_path = "../../log-analytics-workspace/workspace"
}

dependency "acr"{
  config_path = "../../acr/repo"
}

inputs = {
  subscription_id = include.main_env.locals.subscription_id
  role_assignments = {
    role1 = {
      scope = dependency.function_metadata.outputs.storage_id
      role_definition_name = "Storage Blob Data Owner"
    }
    role2 = {
      scope = dependency.application_data_storage.outputs.storage_id
      role_definition_name = "Storage Blob Data Owner"
    }
    role3 = {
      scope = dependency.function_metadata.outputs.storage_id
      role_definition_name = "Storage Table Data Contributor"
    }
    role4 = {
      scope = dependency.application_data_storage.outputs.storage_id
      role_definition_name = "Storage Table Data Contributor"
    }
    role5 = {
      scope = dependency.application_data_storage.outputs.storage_id
      role_definition_name = "Storage Queue Data Contributor"
    }
    role6 = {
      scope = dependency.function_metadata.outputs.storage_id
      role_definition_name = "Storage Queue Data Contributor"
    }
    role7 = {
      scope = dependency.application_data_storage.outputs.storage_id
      role_definition_name = "Storage Account Contributor"
    }
    role8 = {
      scope = dependency.function_metadata.outputs.storage_id
      role_definition_name = "Storage Account Contributor"
    }
    role9 = {
      scope = dependency.keyvault_id.outputs.keyvault_id
      role_definition_name = "Key Vault Secrets User"
    }
    role10 = {
      scope = dependency.acr.outputs.acr_id
      role_definition_name = "AcrPull"
    }
    role11 = {
      scope = dependency.log_analytics.outputs.log_analytics_workspace_id
      role_definition_name = "Monitoring Contributor"
    }
  }
  managed_identity_principal_id = dependency.func.outputs.system_assigned_principal_id
}