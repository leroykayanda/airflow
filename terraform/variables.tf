#vpc
variable "vpc_id" {
  type = map(string)
  default = {
    "dev"   = "vpc-0586a91d3285f74ca"
    "stage" = "vpc-01ffc244c8957b246"
    "sand"  = "vpc-00cd1a802fa8b30e3"
    "prod"  = "vpc-0b5114eaa9408bab3"
  }
}

variable "vpc_cidr" {
  type = map(string)
  default = {
    "dev"   = "10.1.0.0/16"
    "stage" = "10.2.0.0/16"
    "sand"  = "10.6.0.0/16"
    "prod"  = "10.3.0.0/16"
  }
}

variable "private_subnets" {
  type = map(list(string))
  default = {
    "dev"   = ["subnet-01a7f68b3281a0062", "subnet-08362c4d63ea25326"],
    "stage" = ["subnet-0427cff875c517252", "subnet-039e8927cd8f1a352"],
    "sand"  = ["subnet-0a88363f4e664e433", "subnet-0e7de5751b3ad235e"],
    "prod"  = ["subnet-0bda249263d36390e", "subnet-0250d21e4175d4b0a"]
  }
}

variable "public_subnets" {
  type = map(list(string))
  default = {
    "dev"   = ["subnet-01a7f68b3281a0062", "subnet-08362c4d63ea25326"],
    "stage" = ["subnet-02c830b731654f848", "subnet-0533bd5827ce9806c"],
    "sand"  = ["subnet-02427453b97a9b9b1", "subnet-0549592b3eca15d57"],
    "prod"  = ["subnet-0b453bc95ec557210", "subnet-085e37e8a88813d9e"]
  }
}


variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "team" {
  type        = string
  description = "Used to tag resources"
  default     = "data"
}

variable "microservice_name" {
  type        = string
  description = "Name of the ECS service"
  default     = "airflow"
}

variable "instance_class" {
  type        = string
  description = "eg db.t4g.micro"
  default     = "db.t4g.small"
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = "arn:aws:sns:eu-west-1:123456789:dev-devops-alerts"
}

variable "engine" {
  type        = string
  description = "The database engine to use eg.mysql,postgres"
  default     = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "14.7"
}

variable "username" {
  type    = string
  default = "air"
}

variable "password" {
  type = string
}

variable "backup_retention_period" {
  type    = number
  default = 15
}

variable "port" {
  type    = number
  default = 5432
}

variable "create_cpu_credit_alarm" {
  type        = string
  description = "Create alarm only if a burstable instance class has been chosen. Possible values - yes or no"
  default     = "yes"
}

variable "maintenance_window" {
  type    = string
  default = "Sat:00:00-Sat:02:00"
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window.Eg: Mon:00:00-Mon:03:00"
  default     = "02:00-04:00"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gibibytes"
  default     = 20
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created."
  default     = "air"
}

variable "deletion_protection" {
  default = true
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine). MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace."
  default     = ["postgresql"]
}

variable "multi_az" {
  default = false
}

variable "memory_alarm_threshold" {
  type        = number
  description = "Threshold for memory DB alarm to trigger in bytes"
  default     = 200000000
}

variable "multi_az_enabled" {
  default = false
}

variable "automatic_failover_enabled" {
  default = false
}

variable "num_cache_clusters" {
  type        = number
  description = "Number of redis nodes"
  default     = 1
}

variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "redis_engine_version" {
  type    = string
  default = "7.0"
}

variable "redis_parameter_group_name" {
  type    = string
  default = "default.redis7"
}

variable "capacity_provider" {
  type        = string
  description = "Short name of the ECS capacity provider"
  default     = "FARGATE"
}

variable "webserver_command" {
  type    = list(string)
  default = ["webserver"]
}

variable "user" {
  type    = string
  default = "50000:0"
}

variable "webserver_fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 1024
}

variable "webserver_fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "worker_environment_variables" {
  type    = list(map(string))
  default = [{ "name" : "DUMB_INIT_SETSID", "value" : 0 }]
}

variable "webserver_desired_count" {
  type        = number
  description = "Desired number of tasks"
  default     = 1
}

variable "certificate_arn" {
  type        = string
  description = "Certificate for the ALB HTTPS listener"
  default     = "arn:aws:acm:eu-west-1:123456789:certificate/88366873-cf84-4c97-ae7b-aff950f5b9f6"
}

variable "waf" {
  type        = string
  description = "Tag used by AWS Firewall manager to determine whether or not to associate a WAF. Value can be yes or no "
  default     = "no"
}

variable "zone_id" {
  type        = string
  description = "Hosted Zone ID for the zone you want to create the ALB DNS record in"
  default     = ""
}

variable "webserver_domain_name" {
  type        = string
  description = "DNS name in your hosted zone that you want to point to the ALB"
  default     = ""
}

variable "webserver_min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
  default     = 1
}

variable "webserver_max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
  default     = 2
}

variable "webserver_internal" {
  description = "Boolean - whether the ALB is internal or not"
  default     = true
}

variable "webserver_deregistration_delay" {
  type        = number
  description = "ALB target group deregistration delay"
  default     = 5
}

variable "webserver_container_port" {
  type        = number
  description = "Port used by the container to receive traffic"
  default     = 8080
}

variable "scheduler_fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 1024
}

variable "scheduler_fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "scheduler_desired_count" {
  type        = number
  description = "Desired number of tasks"
  default     = 1
}

variable "scheduler_min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
  default     = 1
}

variable "scheduler_max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
  default     = 1
}

variable "scheduler_command" {
  type    = list(string)
  default = ["scheduler"]
}

variable "worker_fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 4096
}

variable "worker_fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 16384
}

variable "worker_desired_count" {
  type        = number
  description = "Desired number of tasks"
  default     = 2
}

variable "worker_min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
  default     = 2
}

variable "worker_max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
  default     = 4
}

variable "worker_command" {
  type    = list(string)
  default = ["celery", "worker"]
}

variable "worker_container_port" {
  type        = number
  description = "Port used by the container to receive traffic"
  default     = 8793
}

variable "mountPoints" {
  type        = list(map(string))
  description = "Port used by the container to receive traffic"
  default = [
    {
      "containerPath" : "/opt/airflow/logs",
      "sourceVolume" : "worker-logs"
    }
  ]
}

variable "volume_name" {
  type    = string
  default = "worker-logs"
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "create_volume" {
  type    = string
  default = "yes"
}

variable "company_name" {
  type    = string
  default = "abc"
}

variable "app_s3_bucket_retention" {
  type        = number
  description = "In days"
  default     = 365
}
