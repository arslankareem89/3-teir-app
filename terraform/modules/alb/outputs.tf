output "frontend_target_group_arn" {
  description = "ARN of the frontend target group used by the ECS frontend service"
  value       = aws_lb_target_group.frontend.arn
}

output "alb_dns_name" {
  description = "DNS name of the public ALB"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID for the public ALB"
  value       = aws_lb.this.zone_id
}
