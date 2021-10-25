variable "files" {
  description = "List of files to be added as AWS SSM paramters (Strings or SecretStrings)"
  type = list(object({
    parameter_name = string
    path           = string
    filename       = string
    contents       = string
    sensitive      = bool
  }))
}

variable "environment_variable_prefix" {
  type        = string
  description = "Allows you to configure a unique prefix.  This can be used to identify the environment variables that need to be converted to files in the entry point script."
  default     = "ECS_FILES"
}
