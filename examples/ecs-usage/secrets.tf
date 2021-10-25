module "config_files" {
  source = "../../."

  files = [
    {
      parameter_name = "/${var.project}/test/file"
      path           = "/tmp"
      filename       = "test.txt"
      contents       = "This is a test file generated from an ssm parameter"
      sensitive      = false
      }, {
      parameter_name = "/${var.project}/test/secret-file"
      path           = "/tmp"
      filename       = "secret-test.txt"
      contents       = "This is a secret test file generated from an ssm parameter"
      sensitive      = true
    }
  ]
}
