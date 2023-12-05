variable "non_root_compartment_id" {
  description = "Compartment details"
  type        = string
}

variable "kms_vault_display_name" {
  description = "KMS Vault Display Name"
  type        = string
}

variable "kms_vault_vault_type" {
  description = "KMS Vault Type"
  type        = string
}

#KMS Vault
variable "kms_vault_keys_conf" {
  description = "Vault Key Configurations"
  type = map(object({
    key_display_name    = string
    key_algo            = string
    key_length          = number
    key_protection_mode = string
  }))
}

variable "vault_secrets_conf" {
  description = "Vault Secrets Configurations"
  type = map(object({
    secret_name            = string
    secret_content_name    = string
    secret_content_type    = string
    secret_content_content = string
    enc_key                = string
  }))
}