output "files" {
  description = "Contains a Map of SSM Parameter store Arns for the files that have been added to the module. The key is constructed from the file name and has any character that is not alpha numeric replaced with _.  The key is also changed to upper case as it is intended for use as the name fo the environment variable in consuming terraform configurations."
  value       = { for k, v in aws_ssm_parameter.config_files : join("_", [var.environment_variable_prefix, upper(replace(k, "/[^A-Za-z0-9]+/", "_"))]) => v.arn }
}

output "iam_policy_arn" {
  description = "Arn of the IAM Policy that allows access to the parameters"
  value       = aws_iam_policy.secret_access.arn
}
