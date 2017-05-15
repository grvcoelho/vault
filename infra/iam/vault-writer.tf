data "aws_iam_policy_document" "vault_write_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      "${var.vault_master_key_arn}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem"
    ]

    resources = [
      "${var.vault_database_arn}"
    ]
  }
}

resource "aws_iam_group" "vault_writers_group" {
  name = "vault_writers"
}

resource "aws_iam_policy" "vault_write_policy" {
  name = "vault_write_policy"
  policy = "${data.aws_iam_policy_document.vault_write_policy_document.json}"
}

resource "aws_iam_policy_attachment" "vault_write_policy_attachment" {
  name = "vault_write_policy_attachment"
  policy_arn = "${aws_iam_policy.vault_write_policy.arn}"

  groups = [
    "${aws_iam_group.vault_writers_group.name}"
  ]
}
