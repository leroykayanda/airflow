module "redis_cluster" {
  source                     = "git@github.com:abc/terraform-modules.git//modules/aws-elasticache?ref=v1.0.20"
  env                        = var.env
  microservice_name          = var.microservice_name
  team                       = var.team
  vpc_id                     = var.vpc_id
  sns_topic                  = var.sns_topic
  vpc_cidr                   = var.vpc_cidr
  private_subnets            = var.private_subnets
  multi_az_enabled           = var.multi_az_enabled
  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = var.automatic_failover_enabled
  node_type                  = var.node_type
  engine_version             = var.redis_engine_version
  parameter_group_name       = var.redis_parameter_group_name
}
