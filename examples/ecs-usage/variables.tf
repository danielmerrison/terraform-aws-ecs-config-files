variable "project" {
  type        = string
  description = "Name of the project"
  default     = "ecs-config-files-ecs-usage"
}

variable "region" {
  type        = string
  description = "Region to use for the deployment"
  default     = "eu-west-2"
}

variable "image_name" {
  type        = string
  description = "Name of the docker image to use"
  default     = "public.ecr.aws/t6i3k6z5/ecs-config-files-example"
}

variable "image_version" {
  type        = string
  description = "Version of the docker image to use"
  default     = ""
}
