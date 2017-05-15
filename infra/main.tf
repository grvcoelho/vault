provider "aws" {
  region = "us-east-1"
}

module "database" {
  source = "./database"
}

module "kms" {
  source = "./kms"
}

module "iam" {
  source = "./iam"

  vault_master_key_arn = "${module.kms.vault_master_key_arn}"
  vault_database_arn = "${module.database.vault_database_arn}"
}
