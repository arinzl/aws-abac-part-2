resource "aws_ssoadmin_instance_access_control_attributes" "attributes" {
  instance_arn = local.sso_instance_arn
  attribute {
    key = "AzureDepartment"
    value {
      source = ["$${path:enterprise.department}"]
    }
  }
}
