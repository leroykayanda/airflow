locals {
  airflow_image_tag = element(data.aws_ecr_image.airflow_image.image_tags, 0)
  private_subnets   = var.private_subnets[var.env]
  vpc_id            = var.vpc_id[var.env]
  vpc_cidr          = var.vpc_cidr[var.env]
  secrets_arn       = "arn:aws:ssm:eu-west-1:123456789:parameter/dev/airflow/"
  app_secrets = [
    { name = "AIRFLOW__CORE__EXECUTOR", valueFrom = "${local.secrets_arn}AIRFLOW__CORE__EXECUTOR" },
    { name = "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN", valueFrom = "${local.secrets_arn}AIRFLOW__DATABASE__SQL_ALCHEMY_CONN" },
    { name = "AIRFLOW__CORE__SQL_ALCHEMY_CONN", valueFrom = "${local.secrets_arn}AIRFLOW__CORE__SQL_ALCHEMY_CONN" },
    { name = "AIRFLOW__CELERY__RESULT_BACKEND", valueFrom = "${local.secrets_arn}AIRFLOW__CELERY__RESULT_BACKEND" },
    { name = "AIRFLOW__CELERY__BROKER_URL", valueFrom = "${local.secrets_arn}AIRFLOW__CELERY__BROKER_URL" },
    { name = "AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION", valueFrom = "${local.secrets_arn}AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION" },
    { name = "AIRFLOW__CORE__LOAD_EXAMPLES", valueFrom = "${local.secrets_arn}AIRFLOW__CORE__LOAD_EXAMPLES" },
    { name = "AIRFLOW__API__AUTH_BACKENDS", valueFrom = "${local.secrets_arn}AIRFLOW__API__AUTH_BACKENDS" },
    { name = "_PIP_ADDITIONAL_REQUIREMENTS", valueFrom = "${local.secrets_arn}_PIP_ADDITIONAL_REQUIREMENTS" },
    { name = "AIRFLOW__CORE__FERNET_KEY", valueFrom = "${local.secrets_arn}AIRFLOW__CORE__FERNET_KEY" },
    { name = "AIRFLOW__WEBSERVER__SECRET_KEY", valueFrom = "${local.secrets_arn}AIRFLOW__WEBSERVER__SECRET_KEY" },
  ]
}
