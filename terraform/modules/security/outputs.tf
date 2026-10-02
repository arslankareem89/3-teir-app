output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}


output "frontend_security_group_id" {
  description = "Frontend ECS security group ID"
  value       = aws_security_group.frontend.id
}


output "backend_security_group_id" {
  description = "Backend ECS security group ID"
  value       = aws_security_group.backend.id
}


output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}


output "vpc_endpoint_security_group_id" {
  description = "Security group ID for AWS VPC interface endpoints"
  value       = aws_security_group.vpc_endpoints.id
}