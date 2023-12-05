resource "oci_kms_vault" "kms_vault_management" {
  compartment_id = var.non_root_compartment_id
  display_name   = var.kms_vault_display_name
  vault_type     = var.kms_vault_vault_type
}

resource "oci_kms_key" "key_management" {
  #Required
  compartment_id = var.non_root_compartment_id
  for_each       = var.kms_vault_keys_conf
  display_name   = each.value.key_display_name
  key_shape {
    #Required
    algorithm = each.value.key_algo
    length    = each.value.key_length
  }
  management_endpoint = data.oci_kms_vaults.get_specific_vault.vaults[0].management_endpoint

  #Optional
  protection_mode = each.value.key_protection_mode
}

resource "oci_vault_secret" "secret_management" {
  #Required
  compartment_id = var.non_root_compartment_id
  #  vault_id       = data.oci_kms_vaults.get_specific_vault.vaults[0].id
  vault_id = oci_kms_vault.kms_vault_management.id
  #  key_id         = data.oci_kms_keys.get_keys.keys[0].id
  for_each = var.vault_secrets_conf
  key_id   = oci_kms_key.key_management[each.value.enc_key].id
  secret_content {
    #Required
    content_type = each.value.secret_content_type
    #Optional
    content = each.value.secret_content_content
    name    = each.value.secret_content_name
  }
  secret_name = each.value.secret_name
}