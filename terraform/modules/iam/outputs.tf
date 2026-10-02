output "task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.task_execution.arn
}

output "frontend_task_role_arn" {
  description = "Frontend ECS task role ARN"
  value       = aws_iam_role.frontend_task.arn
}

output "backend_task_role_arn" {
  description = "Backend ECS task role ARN"
  value       = aws_iam_role.backend_task.arn
}

output "ecs_instance_role_arn" {
  description = "ECS EC2 container instance role ARN"
  value       = aws_iam_role.ecs_instance.arn
}