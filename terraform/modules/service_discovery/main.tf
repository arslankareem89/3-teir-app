resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "${var.project_name}.internal"
  description = "Private service discovery for ${var.project_name} ECS tasks"
  vpc         = var.vpc_id

  tags = {
    Name        = "${var.project_name}-service-discovery"
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_service_discovery_service" "backend" {
  name = "backend"

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.this.id
    routing_policy = "MULTIVALUE"

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  tags = {
    Name        = "${var.project_name}-backend-discovery"
    Project     = var.project_name
    Environment = "dev"
  }
}