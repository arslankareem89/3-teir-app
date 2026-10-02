variable "project_name" {
  description = "Project name"
  type        = string
}


variable "vpc_id" {
  description = "VPC ID"
  type        = string
}


variable "private_subnet_ids" {
  description = "Private subnet IDs for endpoints"
  type        = list(string)
}


variable "security_group_id" {
  description = "Security group for VPC endpoints"
  type        = string
}

variable "route_table_ids" {
  description = "Route tables that need access to gateway endpoints such as S3"
  type        = list(string)
  default     = []
}