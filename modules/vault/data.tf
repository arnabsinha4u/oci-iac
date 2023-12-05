data "oci_kms_vaults" "get_specific_vault" {
  #Required
  compartment_id = var.non_root_compartment_id
  filter {
    name   = "display_name"
    values = [var.kms_vault_display_name]
  }
  depends_on = [oci_kms_vault.kms_vault_management]
}

data "oci_kms_keys" "get_keys" {
  #Required
  compartment_id      = var.non_root_compartment_id
  management_endpoint = data.oci_kms_vaults.get_specific_vault.vaults[0].management_endpoint
  depends_on          = [oci_kms_key.key_management]
}