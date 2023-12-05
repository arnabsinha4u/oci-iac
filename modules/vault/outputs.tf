output "vault_details" {
  value       = oci_kms_vault.kms_vault_management
  description = "Vault Details"
  sensitive   = false
}

output "key_details" {
  value       = oci_kms_key.key_management
  description = "Key Details"
  sensitive   = false
}

output "secrets_details" {
  value       = oci_vault_secret.secret_management
  description = "Secret Details"
  sensitive   = false
}