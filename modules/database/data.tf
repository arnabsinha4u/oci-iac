/*
data "oci_core_subnets" "get_subnets" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id
}

data "oci_core_subnets" "get_subnet_id_mysql_db_disp_name" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id
  display_name   = local.mysql_db_disp_name[0]
}
*/

data "oci_vault_secrets" "get_secrets" {
  #Required
  compartment_id = var.non_root_compartment_id
  name           = var.mysql_db_conf.mysql_db_secret_name
}

data "oci_secrets_secretbundle" "secret_bundle" {
  secret_id = data.oci_vault_secrets.get_secrets.secrets[0].id
}