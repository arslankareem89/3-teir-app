output "frontend_ecr_repository_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr.frontend_repository_url
}

output "backend_ecr_repository_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr.backend_repository_url
}

output "vpc_id" {
  description = "Application VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.network.private_db_subnet_ids
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = module.rds.db_port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = module.rds.db_name
}

output "rds_secret_arn" {
  description = "RDS-managed Secrets Manager secret ARN"
  value       = module.rds.db_secret_arn
}

output "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = module.iam.task_execution_role_arn
}

output "frontend_task_role_arn" {
  description = "Frontend ECS task role ARN"
  value       = module.iam.frontend_task_role_arn
}

output "backend_task_role_arn" {
  description = "Backend ECS task role ARN"
  value       = module.iam.backend_task_role_arn
}

output "ecs_instance_role_arn" {
  description = "ECS EC2 container instance role ARN"
  value       = module.iam.ecs_instance_role_arn
}
output "vpc_endpoint_ids" {
  description = "VPC interface endpoint IDs"

  value = module.vpc_endpoints.endpoint_ids
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_frontend_service_name" {
  description = "Frontend ECS service name"
  value       = module.ecs.frontend_service_name
}

output "ecs_backend_service_name" {
  description = "Backend ECS service name"
  value       = module.ecs.backend_service_name
}

output "backend_service_discovery_arn" {
  description = "Cloud Map service ARN for ECS backend service registration"
  value       = module.service_discovery.backend_service_arn
}

output "backend_service_dns_name" {
  description = "Private DNS name for the backend service"
  value       = module.service_discovery.backend_dns_name
}