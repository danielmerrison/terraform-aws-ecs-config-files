terraform {
  required_version = "~> 1"
  required_providers {
    aws = {
      version = "~> 3"
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

resource "random_uuid" "iam_policy_uuid" {
}

resource "aws_ssm_parameter" "config_files" {
  for_each = { for file in var.files : file.filename => file }

  name = each.value.parameter_name
  value = jsonencode({
    file     = join("/", [each.value.path, each.value.filename]),
    contents = base64encode(each.value.contents)
  })

  type = each.value.sensitive ? "SecureString" : "String"
}

data "aws_iam_policy_document" "secret_access" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]
    resources = [for k, v in aws_ssm_parameter.config_files : v.arn]
  }
}

resource "aws_iam_policy" "secret_access" {
  name   = "ECSConfigFiles-${random_uuid.iam_policy_uuid.result}"
  policy = data.aws_iam_policy_document.secret_access.json
}
