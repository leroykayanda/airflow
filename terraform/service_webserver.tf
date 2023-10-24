resource "aws_iam_role" "webserver_execution_role" {
  name = "${var.env}-${local.webserver_service_name}-Task-Execution-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "webserver_policy_attachment_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.webserver_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "webserver_policy" {
  name = "${local.webserver_service_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "elasticfilesystem:ClientRootAccess"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "webserver_policy_attachment" {
  role       = aws_iam_role.webserver_execution_role.name
  policy_arn = aws_iam_policy.webserver_policy.arn
}

resource "aws_security_group" "webserver_task_sg" {
  name        = "${var.env}-${local.webserver_service_name}-task-sg"
  description = "Control task traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Application Traffic"
    from_port   = var.webserver_container_port
    to_port     = var.webserver_container_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 8793
    to_port     = 8793
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "worker logs"
  }

  egress {
    description = "EFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.env}-${local.webserver_service_name}-task-sg"
  }
}




module "webserver_alb_access_log_bucket" {
  source            = "git@github.com:abc/terraform-modules.git//modules/aws-alb-access-log-bucket?ref=v1.0.27"
  env               = var.env
  team              = var.team
  microservice_name = local.webserver_service_name
}

module "ecsService" {
  source                            = "git@github.com:abc/terraform-modules.git//modules/aws-ecsService?ref=v1.0.60"
  cluster_arn                       = module.ecs_cluster.arn
  container_image                   = "${module.ecr_repo.repository_url}:${local.airflow_image_tag}"
  container_name                    = local.webserver_service_name
  container_port                    = var.webserver_container_port
  env                               = var.env
  region                            = var.region
  service_name                      = "${var.env}-${local.webserver_service_name}"
  task_execution_role               = aws_iam_role.webserver_execution_role.arn
  fargate_cpu                       = var.webserver_fargate_cpu
  fargate_mem                       = var.webserver_fargate_mem
  task_environment_variables        = []
  task_secret_environment_variables = local.app_secrets
  desired_count                     = var.webserver_desired_count
  task_subnets                      = local.private_subnets
  vpc_id                            = local.vpc_id
  vpc_cidr                          = local.vpc_cidr
  alb_access_log_bucket             = module.webserver_alb_access_log_bucket.bucket
  internal                          = var.webserver_internal
  alb_public_subnets                = local.private_subnets
  deregistration_delay              = var.webserver_deregistration_delay
  health_check_path                 = var.health_check_path
  certificate_arn                   = var.certificate_arn
  waf                               = var.waf
  zone_id                           = var.zone_id
  domain_name                       = var.webserver_domain_name
  min_capacity                      = var.webserver_min_capacity
  max_capacity                      = var.webserver_max_capacity
  cluster_name                      = module.ecs_cluster.name
  sns_topic                         = var.sns_topic
  team                              = var.team
  capacity_provider                 = var.capacity_provider
  task_sg                           = aws_security_group.webserver_task_sg.id #optional variables follow
  command                           = var.webserver_command
  user                              = var.user
  create_volume                     = var.create_volume
  volume_name                       = var.volume_name
  file_system_id                    = module.efs.id
  mountPoints                       = var.mountPoints
  access_point_id                   = module.efs.access_point_id
}
