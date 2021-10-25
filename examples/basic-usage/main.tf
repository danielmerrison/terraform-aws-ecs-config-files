terraform {
  required_version = "1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "example" {
  source = "../../."

  files = [
    {
      parameter_name = "/example/test/file"
      path           = "/tmp"
      filename       = "test.txt"
      contents       = "This is a test file generated from an ssm parameter"
      sensitive      = false
      }, {
      parameter_name = "/example/test/secret-file"
      path           = "/tmp"
      filename       = "secret-test.txt"
      contents       = "This is a secret test file generated from an ssm parameter"
      sensitive      = true
    }
  ]
}
