#Variables for subnet
variable "non_root_compartment_id" {
  description = "Compartment details"
  type        = string
}

variable "vcn_id" {
  description = "VCN ID"
  type        = string
}

variable "oke_cluster_conf" {
  description = "OKE Cluster configuration"
  type = object({
    cluster_name            = string
    oke_version             = string
    oke_api_subnet_key      = string
    oke_srv_lb_subnet_key   = string
    is_pod_security_enabled = bool
    is_public_ip_enabled    = bool
  })
}

variable "oke_node_conf" {
  description = "OKE Node configuration"
  type = map(object({
    oke_node_pool_name              = string
    oke_node_pool_size              = number
    oke_node_pool_eviction_duration = string
    oke_node_pool_shape_mem_gbs     = number
    oke_node_pool_shape_ocpu        = number
    oke_node_pool_shape             = string
    oke_node_subnet_key             = string
    oke_node_pool_image_id          = string
  }))
}

variable "network_details" {
  description = "Input network details"
  default     = {}
}