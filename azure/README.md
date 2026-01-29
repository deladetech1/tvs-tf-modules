# Azure Terraform Modules

This directory contains reusable Terraform modules for Azure infrastructure provisioning. Each module is designed to be self-contained, production-ready, and follows Azure best practices and security guidelines.

## 📋 Available Modules

| Module | Description | Key Features |
|--------|-------------|--------------|
| **[acr](./acr/)** | Azure Container Registry | Private registries, image scanning, geo-replication |
| **[api](./api/)** | Azure API configuration | RESTful APIs, OpenAPI support, rate limiting |
| **[apimanager](./apimanager/)** | Azure API Management service | API gateway, developer portal, analytics |
| **[application-insight](./application-insight/)** | Application Insights monitoring | Performance monitoring, custom metrics, alerts |
| **[containerapp](./containerapp/)** | Azure Container Apps deployment | Serverless containers, auto-scaling, ingress |
| **[containerapp-env](./containerapp-env/)** | Container Apps Environment | Managed environment for container apps |
| **[function](./function/)** | Azure Functions deployment | Serverless compute, event-driven architecture |
| **[keyvault](./keyvault/)** | Azure Key Vault provisioning | Secret management, certificate storage, key encryption |
| **[keyvault-secrets](./keyvault-secrets/)** | Key Vault secret management | Secret creation, rotation, access policies |
| **[log-analytics-workspace](./log-analytics-workspace/)** | Log Analytics workspace | Centralized logging, query analytics, insights |
| **[managed-identity](./managed-identity/)** | Managed Identity configuration | System/user-assigned identities, RBAC |
| **[postgresql](./postgresql/)** | Azure Database for PostgreSQL | Managed PostgreSQL, high availability, backup |
| **[postgresql-database](./postgresql-database/)** | PostgreSQL database creation | Database provisioning, user management |
| **[public-dns](./public-dns/)** | Azure DNS zone management | Public DNS zones, record management |
| **[redis](./redis/)** | Azure Cache for Redis | In-memory caching, clustering, persistence |
| **[resource-group](./resource-group/)** | Resource group provisioning | Resource organization, lifecycle management |
| **[role-assignment](./role-assignment/)** | Azure RBAC role assignments | Permission management, access control |
| **[ssl-cert](./ssl-cert/)** | SSL certificate management | Certificate provisioning, auto-renewal |
| **[storage-account](./storage-account/)** | Storage account creation | Blob, file, queue, table storage |
| **[storage-container](./storage-container/)** | Blob storage container | Container management, access policies |
| **[storage-queue](./storage-queue/)** | Storage queue configuration | Message queuing, async processing |

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0.0
- Azure CLI configured with appropriate credentials
- Azure provider >= 3.0.0

### Authentication

```bash
# Option 1: Azure CLI login
az login
az account set --subscription "your-subscription-id"

# Option 2: Service Principal (recommended for CI/CD)
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"

# Option 3: Managed Identity (recommended for Azure-hosted agents)
# No additional configuration needed
```

### Basic Usage

```hcl
# Example: Create a resource group
module "resource_group" {
  source = "./azure/resource-group"
  
  resource_group_name     = "my-rg"
  resource_group_location = "East US"
  subscription_id         = var.subscription_id
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "team@company.com"
  }
}

# Example: Create a container app
module "container_app" {
  source = "./azure/containerapp"
  
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
  
  tags = {
    Environment = "production"
  }
}

# Example: Create a PostgreSQL database
module "postgresql" {
  source = "./azure/postgresql"
  
  resource_group_name = module.resource_group.name
  server_name         = "my-postgres-server"
  location           = "East US"
  sku_name           = "GP_Gen5_2"
  version            = "13"
  
  administrator_login    = "adminuser"
  administrator_password = var.db_password
  
  backup_retention_days = 7
  geo_redundant_backup_enabled = true
  
  tags = {
    Environment = "production"
  }
}
```

## 📁 Module Structure

Each Azure module follows this standard structure:

```
module-name/
├── main.tf        # Primary Azure resource definitions
├── variables.tf   # Input variable declarations
├── outputs.tf     # Output value declarations
├── providers.tf    # Azure provider configuration
├── version.tf      # Terraform and provider version constraints
└── README.md       # Module-specific documentation
```

## 🔧 Common Patterns

### Tagging Strategy

All modules support consistent Azure tagging:

```hcl
tags = {
  Environment   = "production"    # dev, staging, production
  Project       = "my-project"    # Project identifier
  Owner         = "team@company"  # Team or individual
  CostCenter    = "engineering"   # Cost allocation
  Backup        = "daily"         # Backup requirements
  Compliance    = "pci-dss"       # Compliance requirements
  DataClass     = "confidential"  # Data classification
}
```

### Security Best Practices

- **Encryption**: All modules enable encryption at rest and in transit
- **Access Control**: RBAC with least privilege principles
- **Network Security**: Private endpoints and network isolation
- **Monitoring**: Azure Monitor integration for logging and metrics
- **Identity**: Managed Identity for service-to-service authentication

### Cost Optimization

- **Resource Tagging**: Comprehensive tagging for cost allocation
- **Lifecycle Management**: Automated resource cleanup
- **Right-sizing**: Appropriate SKUs and performance tiers
- **Reserved Instances**: Support for reserved capacity where applicable

## 📊 Module Categories

### Compute & Serverless

#### Container Apps
- **Use Case**: Microservices, event-driven applications
- **Features**: Serverless containers, auto-scaling, ingress
- **Best For**: Web APIs, background jobs, event processing

#### Azure Functions
- **Use Case**: Event-driven serverless compute
- **Features**: Multiple triggers, consumption/premium plans
- **Best For**: Data processing, webhooks, scheduled tasks

### Database & Storage

#### PostgreSQL
- **Use Case**: Relational database for applications
- **Features**: High availability, automated backups, scaling
- **Best For**: Web applications, data analytics, content management

#### Redis Cache
- **Use Case**: In-memory caching and session storage
- **Features**: Clustering, persistence, geo-replication
- **Best For**: Application caching, real-time analytics

#### Storage Account
- **Use Case**: Object storage, file shares, queues
- **Features**: Multiple storage types, lifecycle management
- **Best For**: File uploads, backups, message queuing

### Security & Identity

#### Key Vault
- **Use Case**: Secret and certificate management
- **Features**: Hardware security modules, access policies
- **Best For**: Application secrets, SSL certificates, encryption keys

#### Managed Identity
- **Use Case**: Service-to-service authentication
- **Features**: System/user-assigned identities, RBAC
- **Best For**: Azure service authentication, cross-service access

### Monitoring & Analytics

#### Application Insights
- **Use Case**: Application performance monitoring
- **Features**: Custom metrics, distributed tracing, alerts
- **Best For**: Application monitoring, performance optimization

#### Log Analytics
- **Use Case**: Centralized logging and analytics
- **Features**: Query analytics, insights, data export
- **Best For**: Security monitoring, compliance reporting

### API Management

#### API Management
- **Use Case**: API gateway and developer portal
- **Features**: Rate limiting, authentication, analytics
- **Best For**: API monetization, developer experience

## 🔍 Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # Check Azure CLI authentication
   az account show
   
   # Verify service principal permissions
   az role assignment list --assignee your-client-id
   ```

2. **Resource Conflicts**
   ```bash
   # Check for existing resources
   az resource list --resource-group my-rg
   az storage account list
   ```

3. **Subscription Issues**
   ```bash
   # Verify current subscription
   az account show --query "name"
   
   # List available subscriptions
   az account list --output table
   ```

### Debugging

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Validate configuration
terraform validate

# Plan with detailed output
terraform plan -detailed-exitcode

# Check Azure provider version
terraform version
```

## 📚 Additional Resources

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)
- [Azure Cost Management](https://docs.microsoft.com/en-us/azure/cost-management-billing/)

## 🤝 Contributing

When adding new Azure modules:

1. Follow the standard module structure
2. Include comprehensive variable descriptions
3. Add appropriate outputs for integration
4. Include security best practices
5. Test with `terraform validate` and `terraform plan`
6. Update this README with module information
7. Ensure version constraints are properly set

## 📄 License

_Add your license information here_

---

**Maintained by**: Delade Tech  
**Last Updated**: October 2025

