resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the public application load balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-frontend-sg"
  description = "Security group for the frontend ECS service"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-frontend-sg"
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.project_name}-backend-sg"
  description = "Security group for the backend ECS service"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-backend-sg"
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-rds-sg"
    Project     = var.project_name
    Environment = "dev"
  }
}

# ---------------------------------------------------------
# ALB
# Internet -> ALB :80
# ---------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP traffic from the internet"
}

# ALB -> Frontend :8080

resource "aws_vpc_security_group_egress_rule" "alb_to_frontend" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.frontend.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  description                  = "Allow ALB traffic to frontend ECS service"
}

# ---------------------------------------------------------
# Frontend
# ALB -> Frontend :8080
# ---------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "frontend_from_alb" {
  security_group_id            = aws_security_group.frontend.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  description                  = "Allow traffic from ALB"
}

# Frontend -> Backend :8000

resource "aws_vpc_security_group_egress_rule" "frontend_to_backend" {
  security_group_id            = aws_security_group.frontend.id
  referenced_security_group_id = aws_security_group.backend.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  description                  = "Allow frontend to backend application traffic"
}

# Frontend -> AWS VPC endpoints :443
# Used later for private ECR, CloudWatch Logs, Secrets Manager, etc.

resource "aws_vpc_security_group_egress_rule" "frontend_to_vpc_https" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS traffic to AWS services through VPC endpoints"
}

# ---------------------------------------------------------
# Backend
# Frontend -> Backend :8000
# ---------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "backend_from_frontend" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.frontend.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  description                  = "Allow frontend service traffic"
}

# Backend -> PostgreSQL :5432

resource "aws_vpc_security_group_egress_rule" "backend_to_rds" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.rds.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow backend to PostgreSQL"
}

# Backend -> AWS VPC endpoints :443

resource "aws_vpc_security_group_egress_rule" "backend_to_vpc_https" {
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS traffic to AWS services through VPC endpoints"
}

# ---------------------------------------------------------
# RDS
# Backend -> RDS :5432
# ---------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "rds_from_backend" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.backend.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow PostgreSQL only from backend ECS service"
}