
resource "aws_iam_role" "scheduler_execution_role" {
  name = "${var.env}-${local.scheduler_service_name}-Task-Execution-Role"
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

resource "aws_iam_role_policy_attachment" "scheduler_policy_attachment_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.scheduler_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "scheduler_policy" {
  name = "${local.scheduler_service_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler_policy_attachment" {
  role       = aws_iam_role.scheduler_execution_role.name
  policy_arn = aws_iam_policy.scheduler_policy.arn
}

resource "aws_security_group" "scheduler_task_sg" {
  name        = "${var.env}-${local.scheduler_service_name}-task-sg"
  description = "Control task traffic"
  vpc_id      = var.vpc_id

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
    description = "postgres"
  }

  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "redis"
  }

  egress {
    description = "EFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.env}-${local.scheduler_service_name}-task-sg"
  }
}

module "scheduler_ecs_service_no_ELB" {
  source                            = "git@github.com:Credrails/terraform-modules.git//modules/ecs_service_no_ELB?ref=v1.0.63"
  cluster_arn                       = module.ecs_cluster.arn
  container_image                   = var.airflow_container_image
  container_name                    = local.scheduler_service_name
  env                               = var.env
  region                            = var.region
  service_name                      = "${var.env}-${local.scheduler_service_name}"
  task_execution_role               = aws_iam_role.scheduler_execution_role.arn
  fargate_cpu                       = var.scheduler_fargate_cpu
  fargate_mem                       = var.scheduler_fargate_mem
  task_environment_variables        = []
  task_secret_environment_variables = var.shared_environment_variables
  desired_count                     = var.scheduler_desired_count
  task_subnets                      = var.private_subnets
  vpc_id                            = var.vpc_id
  vpc_cidr                          = var.vpc_cidr
  min_capacity                      = var.scheduler_min_capacity
  max_capacity                      = var.scheduler_max_capacity
  cluster_name                      = module.ecs_cluster.name
  sns_topic                         = var.sns_topic
  team                              = var.team
  capacity_provider                 = var.capacity_provider
  command                           = var.scheduler_command
  user                              = var.user
  task_sg                           = aws_security_group.scheduler_task_sg.id
  create_volume                     = var.create_volume
  volume_name                       = var.volume_name
  file_system_id                    = module.efs.id
  mountPoints                       = var.mountPoints
  access_point_id                   = module.efs.access_point_id
}
