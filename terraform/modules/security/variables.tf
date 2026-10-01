variable "project_name" {
  description = "Project name used for security group naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR used for private AWS service traffic"
  type        = string
}