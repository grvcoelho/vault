resource "aws_kms_key" "vault_master_key" {
  description = "Vault Master Key (VKM) used to encrypt/decrypt credentials"
}
