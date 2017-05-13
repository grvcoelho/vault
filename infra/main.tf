# ============================
# Setup
# ============================

provider "aws" {
  region = "us-east-1"
}

# ============================
# Users
# ============================

resource "aws_iam_group" "vault_readers" {
  name = "vault_readers"
}

resource "aws_iam_group" "vault_writers" {
  name = "vault_writers"
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

# ============================
# Access Policies
# ============================

data "aws_iam_policy_document" "vault_read_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      "${aws_kms_key.vault_master_key.arn}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      "${aws_dynamodb_table.vault_database.arn}"
    ]
  }
}

resource "aws_iam_policy" "vault_read_policy" {
  name = "vault_read_policy"
  policy = "${data.aws_iam_policy_document.vault_read_policy_document.json}"
}

resource "aws_iam_policy_attachment" "vault_read_policy_attachment" {
  name = "vault_read_policy_attachment"
  groups = ["${aws_iam_group.vault_readers.name}"]
  policy_arn = "${aws_iam_policy.vault_read_policy.arn}"
}

data "aws_iam_policy_document" "vault_write_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      "${aws_kms_key.vault_master_key.arn}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem"
    ]

    resources = [
      "${aws_dynamodb_table.vault_database.arn}"
    ]
  }
}

resource "aws_iam_policy" "vault_write_policy" {
  name = "vault_write_policy"
  policy = "${data.aws_iam_policy_document.vault_write_policy_document.json}"
}

resource "aws_iam_policy_attachment" "vault_write_policy_attachment" {
  name = "vault_write_policy_attachment"
  groups = ["${aws_iam_group.vault_writers.name}"]
  policy_arn = "${aws_iam_policy.vault_write_policy.arn}"
}
