data "aws_caller_identity" "current" {}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "network" {
  source = "./modules/network"

  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  vpc_cidr     = var.vpc_cidr
}

module "rds" {
  source = "./modules/rds"

  project_name      = var.project_name
  db_name           = var.db_name
  master_username   = var.db_master_username
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  db_subnet_ids     = module.network.private_db_subnet_ids
  security_group_id = module.security.rds_security_group_id
}

module "iam" {
  source = "./modules/iam"

  project_name   = var.project_name
  account_id     = data.aws_caller_identity.current.account_id
  rds_secret_arn = module.rds.db_secret_arn
}

module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"

  project_name = var.project_name

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_app_subnet_ids

  route_table_ids = concat(
    module.network.private_app_route_table_ids,
    module.network.private_db_route_table_ids
  )

  security_group_id = module.security.vpc_endpoint_security_group_id
}

module "service_discovery" {
  source = "./modules/service_discovery"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}

module "ecs" {
  source = "./modules/ecs"

  project_name                  = var.project_name
  aws_region                    = var.aws_region
  vpc_id                        = module.network.vpc_id
  private_app_subnet_ids        = module.network.private_app_subnet_ids
  frontend_security_group_id    = module.security.frontend_security_group_id
  backend_security_group_id     = module.security.backend_security_group_id
  execution_role_arn            = module.iam.task_execution_role_arn
  frontend_task_role_arn        = module.iam.frontend_task_role_arn
  backend_task_role_arn         = module.iam.backend_task_role_arn
  frontend_image                = "${module.ecr.frontend_repository_url}:healthcheck-20261002-v2"
  backend_image                 = "${module.ecr.backend_repository_url}:latest"
  backend_service_discovery_arn = module.service_discovery.backend_service_arn
  backend_dns_name              = module.service_discovery.backend_dns_name
  frontend_target_group_arn     = module.alb.frontend_target_group_arn
  frontend_allowed_hosts        = "${module.alb.alb_dns_name},localhost,127.0.0.1"
  db_host                       = module.rds.db_endpoint
  db_name                       = module.rds.db_name
  db_username                   = var.db_master_username
  db_secret_arn                 = module.rds.db_secret_arn
  jwt_secret                    = "${var.project_name}-local-jwt-secret"
  django_secret_key             = "${var.project_name}-local-django-secret"
}