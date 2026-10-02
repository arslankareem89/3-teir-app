variable "project_name" {
  description = "Project name used for IAM role naming"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "rds_secret_arn" {
  description = "RDS master credentials secret ARN"
  type        = string
}