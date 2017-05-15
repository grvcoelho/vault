data "aws_iam_policy_document" "vault_read_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      "${var.vault_master_key_arn}"
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
      "${var.vault_database_arn}"
    ]
  }
}

resource "aws_iam_group" "vault_readers_group" {
  name = "vault_readers"
}

resource "aws_iam_policy" "vault_read_policy" {
  name = "vault_read_policy"
  policy = "${data.aws_iam_policy_document.vault_read_policy_document.json}"
}

resource "aws_iam_policy_attachment" "vault_read_policy_attachment" {
  name = "vault_read_policy_attachment"
  policy_arn = "${aws_iam_policy.vault_read_policy.arn}"

  groups = [
    "${aws_iam_group.vault_readers_group.name}"
  ]
}
