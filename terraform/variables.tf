variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for AWS resource naming"
  type        = string
  default     = "3-tier-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the application VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by the application"
  type        = list(string)
  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDRs"
  type        = list(string)
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDRs"
  type        = list(string)
  default = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]
}