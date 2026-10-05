# 3-Tier AWS ECS Application

Hands-on AWS DevOps learning project.

## Stack

* AWS ECS
* Fargate
* ECR
* ALB
* RDS PostgreSQL
* Cloud Map
* ECS Fargate
* Terraform
* Docker

## Architecture

Frontend → Backend → PostgreSQL

## Region

`ap-south-1`

## Goal

Build and deploy a 3-tier application on AWS while learning ECS Fargate, Terraform, networking, security, and CI/CD.

## Runtime configuration

The frontend listens on port `8080` and calls the backend using `BACKEND_URL`. In ECS, use the Cloud Map DNS name from the `backend_service_dns_name` Terraform output with port `8000`.

The backend listens on port `8000`. For RDS, provide `DB_HOST`, `DB_NAME`, `DB_PORT`, `DB_USER`, and `DB_PASSWORD`; the username and password should be injected from the RDS-managed Secrets Manager secret. Provide `JWT_SECRET` from a separate production secret. The frontend requires `DJANGO_SECRET_KEY`, `DJANGO_ALLOWED_HOSTS`, and `DJANGO_DEBUG=false`. Keep `DJANGO_SESSION_COOKIE_SECURE=true` when serving the site over HTTPS.

Run database migrations as a one-off task using the backend image and command `alembic upgrade head`, with the same database environment and secret configuration as the backend service. Do not run migrations independently in every backend task during startup.
