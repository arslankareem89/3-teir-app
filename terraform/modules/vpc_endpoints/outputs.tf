output "endpoint_ids" {

  description = "VPC endpoint IDs"

  value = [
    aws_vpc_endpoint.ecr_api.id,
    aws_vpc_endpoint.ecr_dkr.id,
    aws_vpc_endpoint.logs.id,
    aws_vpc_endpoint.secretsmanager.id
  ]
}