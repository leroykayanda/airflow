data "aws_ecr_image" "airflow_image" {
  repository_name = module.ecr_repo.name
  most_recent     = true
}
