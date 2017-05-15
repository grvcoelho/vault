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
