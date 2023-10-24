resource "aws_security_group" "db_security_group" {
  name        = "${var.env}-${var.microservice_name}-allow-db-traffic"
  description = "Allow db inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Aurora Traffic"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "VPN Traffic"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["10.3.0.0/16"]
  }

  tags = {
    Name = "${var.env}-${var.microservice_name}-allow-db-traffic"
  }
}

module "rds" {
  source                          = "git@github.com:abc/terraform-modules.git//modules/aws-rds?ref=v1.0.18"
  env                             = var.env
  team                            = var.team
  microservice_name               = var.microservice_name
  db_subnets                      = var.private_subnets
  instance_class                  = var.instance_class
  sns_topic                       = var.sns_topic
  security_group_id               = aws_security_group.db_security_group.id
  engine                          = var.engine
  engine_version                  = var.db_engine_version
  username                        = var.username
  password                        = var.password
  backup_retention_period         = var.backup_retention_period
  port                            = var.port
  create_cpu_credit_alarm         = var.create_cpu_credit_alarm
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  allocated_storage               = var.allocated_storage
  db_name                         = var.db_name
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  multi_az                        = var.multi_az
  memory_alarm_threshold          = var.memory_alarm_threshold
}
