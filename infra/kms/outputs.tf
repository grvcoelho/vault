output "vault_master_key_arn" {
  description = "Vault KMS master key arn"
  value = "${aws_kms_key.vault_master_key.arn}"
}
