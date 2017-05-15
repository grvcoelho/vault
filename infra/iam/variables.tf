variable "vault_master_key_arn" {
  description = "Vault KMS master key arn"
  type = "string"
}

variable "vault_database_arn" {
  description = "Vault DynamoDb table arn"
  type = "string"
}
