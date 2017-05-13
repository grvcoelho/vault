# ============================
# Setup
# ============================

provider "aws" {
  region = "us-east-1"
}

# ============================
# Users
# ============================

resource "aws_iam_user" "vault_client" {
  name = "vault_client"
}

resource "aws_iam_user" "vault_admin" {
  name = "vault_admin"
}

# ============================
# Database
# ============================

resource "aws_dynamodb_table" "vault_database" {
  name = "VaultDatabase"
  read_capacity = 1
  write_capacity = 1
  hash_key = "Name"
  range_key = "Version"

  attribute {
    name = "Name"
    type = "S"
  }

  attribute {
    name = "Version"
    type = "S"
  }
}

# ============================
# Key Management Store
# ============================

resource "aws_kms_key" "vault_master_key" {
  description = "Vault Master Key (VMK) used to encrypt/decrypt credentials"
}

resource "aws_kms_alias" "vault_master_key_alias" {
  name = "alias/vault_master_key"
  target_key_id = "${aws_kms_key.vault_master_key.key_id}"
}



