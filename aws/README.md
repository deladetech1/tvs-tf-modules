# AWS Terraform Modules

This directory contains reusable Terraform modules for AWS infrastructure provisioning. Each module is designed to be self-contained, production-ready, and follows AWS best practices.

## 📋 Available Modules

| Module | Description | Key Features |
|--------|-------------|--------------|
| **[apprunner](./apprunner/)** | AWS App Runner service configuration | Serverless container deployment, auto-scaling, load balancing |
| **[dynamodb](./dynamodb/)** | DynamoDB table provisioning | On-demand/Provisioned billing, encryption, point-in-time recovery |
| **[dynamodb-items](./dynamodb-items/)** | DynamoDB item management | Batch operations, conditional writes, data migration |
| **[ecr](./ecr/)** | Elastic Container Registry setup | Private repositories, image scanning, lifecycle policies |
| **[elastic_cache](./elastic_cache/)** | ElastiCache cluster configuration | Redis/Memcached support, clustering, backup/restore |
| **[iam/role](./iam/role/)** | IAM role creation and management | Trust policies, permissions, cross-account access |
| **[iam/policy](./iam/policy/)** | IAM policy definitions | Custom policies, resource-based permissions |
| **[iam/attachment](./iam/attachment/)** | IAM policy attachments | Role-policy associations, user-policy attachments |
| **[s3/s3_bucket](./s3/s3_bucket/)** | S3 bucket creation and configuration | Versioning, encryption, lifecycle policies, CORS |
| **[s3/s3_enable_website](./s3/s3_enable_website/)** | S3 static website hosting | Public read access, index/error pages, CloudFront integration |
| **[secrets_manager](./secrets_manager/)** | AWS Secrets Manager integration | Secret rotation, cross-region replication, KMS encryption |

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- AWS provider >= 5.0.0

### Authentication

```bash
# Option 1: Environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Option 2: AWS CLI
aws configure

# Option 3: IAM roles (recommended for EC2/ECS/Lambda)
```

### Basic Usage

```hcl
# Example: Create an S3 bucket
module "my_bucket" {
  source = "./aws/s3/s3_bucket"
  
  s3_name = "my-application-bucket"
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "team@company.com"
  }
}

# Example: Create a DynamoDB table
module "my_table" {
  source = "./aws/dynamodb"
  
  table_name = "my-application-table"
  hash_key   = "id"
  range_key  = "timestamp"
  
  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    }
  ]
  
  tags = {
    Environment = "production"
  }
}
```

## 📁 Module Structure

Each AWS module follows this standard structure:

```
module-name/
├── main.tf        # Primary AWS resource definitions
├── variables.tf   # Input variable declarations
├── outputs.tf     # Output value declarations
├── providers.tf   # AWS provider configuration
└── README.md      # Module-specific documentation
```

## 🔧 Common Patterns

### Tagging Strategy

All modules support consistent tagging:

```hcl
tags = {
  Environment   = "production"    # dev, staging, production
  Project       = "my-project"    # Project identifier
  Owner         = "team@company"  # Team or individual
  CostCenter    = "engineering"   # Cost allocation
  Backup        = "daily"          # Backup requirements
  Compliance    = "pci-dss"        # Compliance requirements
}
```

### Security Best Practices

- **Encryption**: All modules enable encryption at rest by default
- **Access Control**: Least privilege IAM policies
- **Network Security**: VPC endpoints where applicable
- **Monitoring**: CloudWatch integration for logging and metrics

### Cost Optimization

- **Resource Tagging**: Comprehensive tagging for cost allocation
- **Lifecycle Policies**: Automated cleanup of unused resources
- **Right-sizing**: Appropriate instance types and storage classes
- **Reserved Capacity**: Support for reserved instances where applicable

## 📊 Module Details

### Compute & Serverless

#### App Runner
- **Use Case**: Containerized applications, microservices
- **Features**: Auto-scaling, load balancing, health checks
- **Best For**: Web applications, APIs, background jobs

### Database & Storage

#### DynamoDB
- **Use Case**: NoSQL database for web applications
- **Features**: On-demand/provisioned billing, global tables
- **Best For**: User sessions, real-time analytics, gaming

#### ElastiCache
- **Use Case**: In-memory caching, session storage
- **Features**: Redis/Memcached, clustering, backup
- **Best For**: Application caching, real-time leaderboards

#### S3
- **Use Case**: Object storage, static websites
- **Features**: Versioning, lifecycle policies, encryption
- **Best For**: File uploads, backups, static content

### Security & Access

#### IAM Modules
- **Use Case**: Identity and access management
- **Features**: Roles, policies, cross-account access
- **Best For**: Service-to-service authentication, user permissions

#### Secrets Manager
- **Use Case**: Secure credential storage
- **Features**: Automatic rotation, cross-region replication
- **Best For**: Database passwords, API keys, certificates

### Container & Registry

#### ECR
- **Use Case**: Private container image registry
- **Features**: Image scanning, lifecycle policies
- **Best For**: Microservices, CI/CD pipelines

## 🔍 Troubleshooting

### Common Issues

1. **Permission Errors**
   ```bash
   # Check AWS credentials
   aws sts get-caller-identity
   
   # Verify IAM permissions
   aws iam list-attached-user-policies --user-name your-user
   ```

2. **Resource Conflicts**
   ```bash
   # Check for existing resources
   aws s3 ls | grep bucket-name
   aws dynamodb list-tables
   ```

3. **Region Mismatches**
   ```bash
   # Verify current region
   aws configure get region
   
   # List available regions
   aws ec2 describe-regions
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
```

## 📚 Additional Resources

- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-resources/)
- [AWS Cost Optimization](https://aws.amazon.com/cost-management/)

## 🤝 Contributing

When adding new AWS modules:

1. Follow the standard module structure
2. Include comprehensive variable descriptions
3. Add appropriate outputs for integration
4. Include security best practices
5. Test with `terraform validate` and `terraform plan`
6. Update this README with module information

## 📄 License

_Add your license information here_

---

**Maintained by**: Delade Tech  
**Last Updated**: October 2025

