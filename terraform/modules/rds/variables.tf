variable "project_name" {
  description = "Project name used for RDS naming"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "appuser"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling in GB"
  type        = number
  default     = 50
}

variable "db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "RDS security group ID"
  type        = string
}