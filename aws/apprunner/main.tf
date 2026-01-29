resource "aws_apprunner_service" "apprunner" {
  service_name = var.service_name

  instance_configuration {
    instance_role_arn = var.appprunner_instance_role_arn
  }
  source_configuration {
    authentication_configuration {
      access_role_arn = var.appprunner_service_role_arn
    }

    image_repository {
      image_configuration {
        port = var.port_number
        runtime_environment_variables = var.runtime_environment_variables
      }
      image_identifier      = var.image_url
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = var.auto_deployments_enabled

  }

}
