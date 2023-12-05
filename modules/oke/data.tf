/*
data "oci_core_subnets" "get_subnets" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id
}

data "oci_core_subnets" "get_subnet_id_oke_api_disp_name" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id
  display_name   = local.oke_api_disp_name[0]
}

data "oci_core_subnets" "get_subnet_id_oke_srvlb_disp_name" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id
  display_name   = local.oke_srvlb_disp_name[0]
}

data "oci_core_subnets" "get_subnet_id_oke_node_disp_name" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id
  display_name   = local.oke_node_disp_name[0]
}
*/