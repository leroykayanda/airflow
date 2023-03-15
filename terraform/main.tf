provider "aws" {
  region = var.region
}

locals {
  webserver_service_name = "airflow-webserver"
  scheduler_service_name = "airflow-scheduler"
  worker_service_name    = "airflow-worker"
  service_name           = "airflow"
}


module "ecs_cluster" {
  source            = "git@github.com:Credrails/terraform-modules.git//modules/aws-ecs-cluster?ref=v1.0.22"
  env               = var.env
  team              = var.team
  microservice_name = var.microservice_name
  capacity_provider = var.capacity_provider
}

module "ecr_repo" {
  source            = "git@github.com:Credrails/terraform-modules.git//modules/aws-ecr-repo?ref=v1.0.36"
  env               = var.env
  microservice_name = var.microservice_name
}
