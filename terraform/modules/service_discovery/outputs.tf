output "backend_service_arn" {
  description = "Cloud Map service ARN to register with the ECS backend service"
  value       = aws_service_discovery_service.backend.arn
}

output "backend_dns_name" {
  description = "Private DNS name for the backend service"
  value       = "backend.${aws_service_discovery_private_dns_namespace.this.name}"
}

output "namespace_id" {
  description = "Cloud Map private DNS namespace ID"
  value       = aws_service_discovery_private_dns_namespace.this.id
}