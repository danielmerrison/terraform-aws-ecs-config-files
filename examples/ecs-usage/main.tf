terraform {
  required_version = "1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  image_version = var.image_version != "" ? var.image_version : chomp(file("./docker/version"))
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0]]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name   = "my-ecs"

  container_insights = true
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
    }
  ]

  tags = {
    Environment = "Development"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECSUsageTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_config_files_ssm_access" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = module.config_files.iam_policy_arn
}

resource "aws_cloudwatch_log_group" "ecs_config_files_example" {
  name              = "ecs-config-files-example"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "ecs_config_files_example" {
  family                   = "ecs-config-files-example"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile("./container-definitions.json.tpl", {
    region        = var.region,
    files         = module.config_files.files,
    image_name    = var.image_name,
    image_version = local.image_version,
  })
}

resource "aws_ecs_service" "ecs_config_files_example" {
  name            = "ecs-config-files-example"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs_config_files_example.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets = module.vpc.private_subnets
  }
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

}
