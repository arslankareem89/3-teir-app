variable "project_name" {
  description = "Project name used for ALB resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group are created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for the application load balancer"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the public ALB"
  type        = string
}
