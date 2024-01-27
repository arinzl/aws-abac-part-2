data "aws_organizations_organization" "org" {}
data "aws_ssoadmin_instances" "this" {}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


locals {
  sso_instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  account_ids           = { for a in data.aws_organizations_organization.org.accounts : a.name => a.id }
}
