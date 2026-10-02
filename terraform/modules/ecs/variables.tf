variable "project_name" {
  description = "Project name used for ECS resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the ECS cluster and services are deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS cluster networking"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private application subnets used by ECS tasks"
  type        = list(string)
}

variable "frontend_security_group_id" {
  description = "Security group ID for the frontend ECS service"
  type        = string
}

variable "backend_security_group_id" {
  description = "Security group ID for the backend ECS service"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "frontend_task_role_arn" {
  description = "ARN of the frontend task execution role"
  type        = string
}

variable "backend_task_role_arn" {
  description = "ARN of the backend task execution role"
  type        = string
}

variable "frontend_image" {
  description = "Full ECR URI for the frontend image"
  type        = string
}

variable "backend_image" {
  description = "Full ECR URI for the backend image"
  type        = string
}

variable "backend_service_discovery_arn" {
  description = "ARN of the backend Cloud Map service definition"
  type        = string
  default     = null
}

variable "backend_dns_name" {
  description = "DNS host name used by frontend to reach backend"
  type        = string
  default     = "backend.local"
}

variable "frontend_target_group_arn" {
  description = "ALB target group ARN that fronts the frontend ECS service"
  type        = string
  default     = null
}

variable "db_host" {
  description = "RDS hostname for the backend task"
  type        = string
  default     = "localhost"
}

variable "db_name" {
  description = "Database name for the backend task"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database username for the backend task"
  type        = string
  default     = "appuser"
}

variable "db_secret_arn" {
  description = "RDS Secrets Manager ARN used to retrieve DB password"
  type        = string
  default     = null
}

variable "jwt_secret" {
  description = "JWT secret used by the backend application"
  type        = string
  default     = "local-development-secret-change-me"
}

variable "django_secret_key" {
  description = "Django secret used by the frontend application"
  type        = string
  default     = "local-development-secret-change-me"
}

variable "frontend_allowed_hosts" {
  description = "Allowed hosts for the frontend service"
  type        = string
  default     = "localhost,127.0.0.1"
}
