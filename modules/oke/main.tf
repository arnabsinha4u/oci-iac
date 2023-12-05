/*
locals {
  oke_api_disp_name   = [for name_check in data.oci_core_subnets.get_subnets.subnets[*].display_name : name_check if length(regexall(".*okeapi", name_check)) > 0]
  oke_srvlb_disp_name = [for name_check in data.oci_core_subnets.get_subnets.subnets[*].display_name : name_check if length(regexall(".*okesrvlb", name_check)) > 0]
  oke_node_disp_name  = [for name_check in data.oci_core_subnets.get_subnets.subnets[*].display_name : name_check if length(regexall(".*okenode", name_check)) > 0]
}
*/

resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id = var.non_root_compartment_id
  vcn_id         = var.vcn_id

  endpoint_config {
    is_public_ip_enabled = var.oke_cluster_conf.is_public_ip_enabled
    #    subnet_id            = data.oci_core_subnets.get_subnet_id_oke_api_disp_name.subnets[0].id
    subnet_id = var.network_details[var.oke_cluster_conf.oke_api_subnet_key].id
  }
  freeform_tags = {
    "OKEclusterName" = var.oke_cluster_conf.cluster_name
  }
  kubernetes_version = var.oke_cluster_conf.oke_version
  name               = var.oke_cluster_conf.cluster_name
  options {
    admission_controller_options {
      is_pod_security_policy_enabled = var.oke_cluster_conf.is_pod_security_enabled
    }
    persistent_volume_config {
      freeform_tags = {
        "OKEclusterName" = var.oke_cluster_conf.cluster_name
      }
    }
    service_lb_config {
      freeform_tags = {
        "OKEclusterName" = var.oke_cluster_conf.cluster_name
      }
    }
    #    service_lb_subnet_ids = [data.oci_core_subnets.get_subnet_id_oke_srvlb_disp_name.subnets[0].id]
    service_lb_subnet_ids = [var.network_details[var.oke_cluster_conf.oke_srv_lb_subnet_key].id]
  }
}

resource "oci_containerengine_node_pool" "create_node_pool_details" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = var.non_root_compartment_id
  for_each       = var.oke_node_conf

  freeform_tags = {
    "OKEnodePoolName" = each.value.oke_node_pool_name
  }
  initial_node_labels {
    key   = "name"
    value = var.oke_cluster_conf.cluster_name
  }
  kubernetes_version = var.oke_cluster_conf.oke_version
  name               = each.value.oke_node_pool_name
  node_config_details {
    freeform_tags = {
      "OKEnodePoolName" = each.value.oke_node_pool_name
    }
    placement_configs {
      availability_domain = "qPqA:EU-FRANKFURT-1-AD-1"
      #      subnet_id           = data.oci_core_subnets.get_subnet_id_oke_node_disp_name.subnets[0].id
      subnet_id = var.network_details[each.value.oke_node_subnet_key].id
    }
    placement_configs {
      availability_domain = "qPqA:EU-FRANKFURT-1-AD-2"
      #subnet_id           = data.oci_core_subnets.get_subnet_id_oke_node_disp_name.subnets[0].id
      subnet_id = var.network_details[each.value.oke_node_subnet_key].id
    }
    placement_configs {
      availability_domain = "qPqA:EU-FRANKFURT-1-AD-3"
      #subnet_id           = data.oci_core_subnets.get_subnet_id_oke_node_disp_name.subnets[0].id
      subnet_id = var.network_details[each.value.oke_node_subnet_key].id
    }
    size = each.value.oke_node_pool_size
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration = each.value.oke_node_pool_eviction_duration
  }
  node_shape = each.value.oke_node_pool_shape
  node_shape_config {
    memory_in_gbs = each.value.oke_node_pool_shape_mem_gbs
    ocpus         = each.value.oke_node_pool_shape_ocpu
  }

  node_source_details {
    image_id    = each.value.oke_node_pool_image_id
    source_type = "IMAGE"
  }
}