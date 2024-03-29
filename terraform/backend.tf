terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "abc"

    workspaces {
      name = "airflow-dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
}
