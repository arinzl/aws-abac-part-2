module "testing" {
  source = "./modules/testing"

  cidr_block_module = var.vpc_cidr_block_root[terraform.workspace]
}


module "iam_identity_center" {
  source = "./modules/iam_identity_center"

}
