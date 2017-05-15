output "vault_database_arn" {
  description = "Vault DynamoDb table arn"
  value = "${aws_dynamodb_table.vault_database.arn}"
}
