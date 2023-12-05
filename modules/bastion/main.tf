resource "oci_bastion_bastion" "manage_bastion" {
  #Required
  compartment_id   = var.non_root_compartment_id
  for_each         = var.bastion_conf
  bastion_type     = each.value.bastion_type
  target_subnet_id = var.network_details[each.value.target_subnet_key].id

  #Optional
  client_cidr_block_allow_list = each.value.client_cidr_block_allow_list
  max_session_ttl_in_seconds   = each.value.max_session_ttl_in_seconds
  name                         = each.value.bastion_name
}