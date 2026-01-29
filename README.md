# Multi-Cloud Terraform Modules

A comprehensive collection of reusable Terraform modules for AWS, Azure, and GCP infrastructure provisioning. This repository provides standardized, production-ready modules to accelerate cloud infrastructure deployment across multiple cloud providers.

## 📋 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Available Modules](#available-modules)
  - [AWS Modules](#aws-modules)
  - [Azure Modules](#azure-modules)
  - [GCP Modules](#gcp-modules)
- [Usage](#usage)
- [Module Structure](#module-structure)
- [Prerequisites](#prerequisites)
- [Contributing](#contributing)

## Overview

This repository contains modular Terraform configurations designed to provision and manage cloud infrastructure resources across AWS, Azure, and GCP. Each module is self-contained, reusable, and follows best practices for infrastructure as code.

### Key Features

- **Multi-Cloud Support**: Modules for AWS, Azure, and GCP
- **Standardized Structure**: Consistent file organization across all modules
- **Reusable Components**: DRY principle applied across infrastructure code
- **Production Ready**: Tested and validated configurations
- **Easy Integration**: Simple module sourcing and usage

## Repository Structure

```
module/
├── aws/           # AWS Terraform modules
├── azure/         # Azure Terraform modules
├── gcp/           # GCP Terraform modules
└── README.md      # This file
```

Each module follows a consistent structure:
```
module-name/
├── main.tf        # Primary resource definitions
├── variables.tf   # Input variable declarations
├── outputs.tf     # Output value declarations
├── providers.tf   # Provider configuration
└── version.tf     # Terraform version constraints (where applicable)
```

## Available Modules

### AWS Modules

| Module | Description |
|--------|-------------|
| **apprunner** | AWS App Runner service configuration |
| **dynamodb** | DynamoDB table provisioning |
| **dynamodb-items** | DynamoDB item management |
| **ecr** | Elastic Container Registry setup |
| **elastic_cache** | ElastiCache cluster configuration |
| **iam/role** | IAM role creation and management |
| **iam/policy** | IAM policy definitions |
| **iam/attachment** | IAM policy attachments |
| **s3/s3_bucket** | S3 bucket creation and configuration |
| **s3/s3_enable_website** | S3 static website hosting |
| **secrets_manager** | AWS Secrets Manager integration |

### Azure Modules

| Module | Description |
|--------|-------------|
| **acr** | Azure Container Registry |
| **api** | Azure API configuration |
| **apimanager** | Azure API Management service |
| **application-insight** | Application Insights monitoring |
| **containerapp** | Azure Container Apps deployment |
| **containerapp-env** | Container Apps Environment setup |
| **function** | Azure Functions deployment |
| **keyvault** | Azure Key Vault provisioning |
| **keyvault-secrets** | Key Vault secret management |
| **log-analytics-workspace** | Log Analytics workspace creation |
| **managed-identity** | Managed Identity configuration |
| **postgresql** | Azure Database for PostgreSQL |
| **postgresql-database** | PostgreSQL database creation |
| **public-dns** | Azure DNS zone management |
| **redis** | Azure Cache for Redis |
| **resource-group** | Resource group provisioning |
| **role-assignment** | Azure RBAC role assignments |
| **ssl-cert** | SSL certificate management |
| **storage-account** | Storage account creation |
| **storage-container** | Blob storage container |
| **storage-queue** | Storage queue configuration |

### GCP Modules

_Coming soon..._

## Usage

### Basic Module Usage

To use a module from this repository, reference it in your Terraform configuration:

#### Example: AWS S3 Bucket

```hcl
module "s3_bucket" {
  source = "git::https://github.com/your-org/module.git//aws/s3/s3_bucket?ref=main"
  
  s3_name = "my-application-bucket"
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

#### Example: Azure Resource Group

```hcl
module "resource_group" {
  source = "git::https://github.com/your-org/module.git//azure/resource-group?ref=main"
  
  resource_group_name     = "my-rg"
  resource_group_location = "eastus"
  subscription_id         = var.subscription_id
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

#### Example: Azure Container App

```hcl
module "container_app" {
  source = "git::https://github.com/your-org/module.git//azure/containerapp?ref=main"
  
  resource_group_name           = module.resource_group.name
  container_app_name            = "my-app"
  container_app_environment_id  = module.containerapp_env.id
  
  workload_profile_name = "Consumption"
  revision_mode         = "Single"
  
  container_name   = "my-container"
  container_image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
  container_cpu    = 0.25
  container_memory = "0.5Gi"
  
  min_replicas = 1
  max_replicas = 3
  
  ingress_target_port = 80
  ingress_transport   = "http"
  
  user_assigned_identity_id     = module.managed_identity.id
  container_registry_host_name  = module.acr.login_server
  subscription_id               = var.subscription_id
  
  secrets = []
  env_variables = []
  traffic_weights = [{
    latest_revision = true
    percentage      = 100
  }]
  
  tags = {
    Environment = "production"
  }
}
```

### Using Local Modules

If you've cloned this repository locally:

```hcl
module "my_module" {
  source = "../../module/aws/s3/s3_bucket"
  
  # module variables...
}
```

## Module Structure

All modules in this repository follow a standard structure:

### `main.tf`
Contains the primary resource definitions for the module.

### `variables.tf`
Declares all input variables required by the module. Each variable includes:
- Type definition
- Description (when applicable)
- Default values (when applicable)

### `outputs.tf`
Defines output values that can be used by other modules or root configurations.

### `providers.tf`
Specifies provider configurations and requirements.

### `version.tf` (Azure modules)
Defines Terraform and provider version constraints.

## Prerequisites

- **Terraform**: >= 1.0.0 (check individual modules for specific version requirements)
- **Cloud Provider CLI**: 
  - AWS CLI (for AWS modules)
  - Azure CLI (for Azure modules)
  - gcloud CLI (for GCP modules)
- **Authentication**: Properly configured cloud provider credentials

### AWS Authentication
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Azure Authentication
```bash
az login
az account set --subscription "your-subscription-id"
```

### GCP Authentication
```bash
gcloud auth application-default login
gcloud config set project your-project-id
```

## Contributing

When adding new modules to this repository, please follow these guidelines:

1. **Module Structure**: Follow the standard structure outlined above
2. **Naming Conventions**: Use lowercase with hyphens for directory names
3. **Documentation**: Include descriptions for all variables and outputs
4. **Testing**: Validate configurations with `terraform validate` and `terraform plan`
5. **Versioning**: Tag releases appropriately for version control

### Adding a New Module

1. Create a new directory under the appropriate cloud provider folder
2. Add the following files:
   - `main.tf`
   - `variables.tf`
   - `outputs.tf`
   - `providers.tf`
   - `version.tf` (optional)
3. Document all variables and outputs
4. Test the module thoroughly
5. Update this README with the new module information

## License

_Add your license information here_

## Support

For issues, questions, or contributions, please contact the infrastructure team or open an issue in this repository.

---

**Maintained by**: Delade Tech  
**Last Updated**: October 2025


