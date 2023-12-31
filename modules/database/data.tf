data "oci_vault_secrets" "get_secrets" {
  #Required
  compartment_id = var.non_root_compartment_id
  name           = var.mysql_db_conf.mysql_db_secret_name
}

data "oci_secrets_secretbundle" "secret_bundle" {
  secret_id = data.oci_vault_secrets.get_secrets.secrets[0].id
}