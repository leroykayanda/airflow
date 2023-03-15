variable "region" {
  type = string
}

variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "microservice_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "instance_class" {
  type        = string
  description = "eg db.t4g.micro"
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = ""
}

variable "engine" {
  type        = string
  description = "The database engine to use eg.mysql,postgres"
}

variable "db_engine_version" {
  type        = string
  description = "eg 14.6"
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "port" {
  type = number
}

variable "create_cpu_credit_alarm" {
  type        = string
  description = "Create alarm only if a burstable instance class has been chosen. Possible values - yes or no"
}

variable "maintenance_window" {
  type        = string
  description = "eg Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window.Eg: Mon:00:00-Mon:03:00"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gibibytes"
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created."
}

variable "deletion_protection" {
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine). MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace."
}

variable "multi_az" {
}

variable "memory_alarm_threshold" {
  type        = number
  description = "Threshold for memory DB alarm to trigger in bytes"
}

variable "multi_az_enabled" {
  default = false
}

variable "automatic_failover_enabled" {
  default = false
}

variable "num_cache_clusters" {
  type        = string
  description = "Number of redis nodes"
}

variable "node_type" {
  type = string
}

variable "redis_engine_version" {
  type = string
}

variable "redis_parameter_group_name" {
  type = string
}

variable "capacity_provider" {
  type        = string
  description = "Short name of the ECS capacity provider"
}

variable "webserver_command" {
  type    = list(string)
  default = []
}

variable "airflow_container_image" {
  type = string
}

variable "user" {
  type    = string
  default = ""
}

variable "webserver_fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 1
}

variable "webserver_fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "shared_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "worker_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "webserver_desired_count" {
  type        = string
  description = "Desired number of tasks"
}

variable "certificate_arn" {
  type        = string
  description = "Certificate for the ALB HTTPS listener"
}

variable "waf" {
  type        = string
  description = "Tag used by AWS Firewall manager to determine whether or not to associate a WAF. Value can be yes or no "
  default     = "yes"
}

variable "zone_id" {
  type        = string
  description = "Hosted Zone ID for the zone you want to create the ALB DNS record in"
}

variable "webserver_domain_name" {
  type        = string
  description = "DNS name in your hosted zone that you want to point to the ALB"
}

variable "webserver_min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
}

variable "webserver_max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
}

variable "webserver_internal" {
  type        = string
  description = "Boolean - whether the ALB is internal or not"
}

variable "webserver_deregistration_delay" {
  type        = number
  description = "ALB target group deregistration delay"
}

variable "webserver_container_port" {
  type        = number
  description = "Port used by the container to receive traffic"
}

variable "scheduler_fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 1
}

variable "scheduler_fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "scheduler_desired_count" {
  type        = string
  description = "Desired number of tasks"
}

variable "scheduler_min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
}

variable "scheduler_max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
}

variable "scheduler_command" {
  type    = list(string)
  default = []
}

variable "worker_fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 1
}

variable "worker_fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "worker_desired_count" {
  type        = string
  description = "Desired number of tasks"
}

variable "worker_min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
}

variable "worker_max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
}

variable "worker_command" {
  type    = list(string)
  default = []
}

variable "worker_container_port" {
  type        = number
  description = "Port used by the container to receive traffic"
}

variable "mountPoints" {
  type        = list(map(string))
  description = "Port used by the container to receive traffic"
}

variable "volume_name" {
  type = string
}

variable "health_check_path" {
  type = string
}

variable "create_volume" {
  type = string
}
