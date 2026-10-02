resource "aws_vpc_endpoint" "ecr_api" {

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.region}.ecr.api"

  vpc_endpoint_type = "Interface"

  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    var.security_group_id
  ]

  private_dns_enabled = true


  tags = {
    Name        = "${var.project_name}-ecr-api-endpoint"
    Project     = var.project_name
    Environment = "dev"
  }
}



resource "aws_vpc_endpoint" "ecr_dkr" {

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"

  vpc_endpoint_type = "Interface"

  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    var.security_group_id
  ]

  private_dns_enabled = true


  tags = {
    Name        = "${var.project_name}-ecr-dkr-endpoint"
    Project     = var.project_name
    Environment = "dev"
  }
}



resource "aws_vpc_endpoint" "logs" {

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.region}.logs"

  vpc_endpoint_type = "Interface"

  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    var.security_group_id
  ]

  private_dns_enabled = true


  tags = {
    Name        = "${var.project_name}-logs-endpoint"
    Project     = var.project_name
    Environment = "dev"
  }
}


resource "aws_vpc_endpoint" "s3" {

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.region}.s3"

  vpc_endpoint_type = "Gateway"

  route_table_ids = var.route_table_ids

  tags = {
    Name        = "${var.project_name}-s3-endpoint"
    Project     = var.project_name
    Environment = "dev"
  }
}



resource "aws_vpc_endpoint" "secretsmanager" {

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.region}.secretsmanager"

  vpc_endpoint_type = "Interface"

  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    var.security_group_id
  ]

  private_dns_enabled = true


  tags = {
    Name        = "${var.project_name}-secrets-endpoint"
    Project     = var.project_name
    Environment = "dev"
  }
}