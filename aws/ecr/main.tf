resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name
}

resource "aws_ecr_lifecycle_policy" "ecr" {
  repository = aws_ecr_repository.ecr.name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Total image before to delete",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}