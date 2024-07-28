resource "aws_ecr_repository" "ecr_repo" {
  name                 = "fe"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "ecr_repo_be1" {
  name                 = "be1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_name" {
   value = aws_ecr_repository.ecr_repo.repository_url
}