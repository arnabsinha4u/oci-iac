#Generic variables
variable "root_compartment_id" {
  description = "Root compartment ID of Tennet tenancy"
  type        = string

  validation {
    condition     = length(var.root_compartment_id) > 4 && substr(var.root_compartment_id, 0, 4) == "ocid"
    error_message = "Please provide a valid value for variable Root Compartment ID."
  }
}

variable "environment_name" {
  description = "Environment Identifier"
  type        = string
  validation {
    condition     = length(var.environment_name) == 3
    error_message = "Please provide a valid value for variable Environment ID."
  }
}

variable "compartment_name" {
  description = "Compartment Name"
  type        = string

  validation {
    condition     = length(var.compartment_name) > 4
    error_message = "Please provide a valid value for variable Compartment Name"
  }
}


variable "compartment_description" {
  description = "Compartment Description"
  type        = string

  validation {
    condition     = length(var.compartment_description) > 6
    error_message = "Please provide a valid value for variable Compartment Description"
  }
}

variable "base_app_name" {
  description = "Base Application Name"
  type        = string

  validation {
    condition     = length(var.base_app_name) >= 3
    error_message = "Please provide a valid value for variable Base App Name"
  }
}

variable "default_availability_domain" {
  description = "Infrastructure default Availability Domain"
  type        = string
}

variable "default_region" {
  description = "Infrastructure default Region"
  type        = string
}

variable "home_region" {
  description = "Infrastructure Home Region"
  type        = string
}

#KMS Vault
variable "kms_vault_type" {
  description = "KMS Vault Type"
  type        = string
}

variable "vault_keys_config" {
  description = "Vault Key Configurations"
  type = map(object({
    key_display_name    = string
    key_algo            = string
    key_length          = number
    key_protection_mode = string
  }))
}

variable "vault_secrets_config" {
  description = "Vault Secrets Configurations"
  type = map(object({
    secret_name            = string
    secret_content_name    = string
    secret_content_type    = string
    secret_content_content = string
    enc_key                = string
  }))
}

#VCN variables
variable "vcn_display_name" {
  description = "VCN Display Name"
  type        = string

  validation {
    condition     = length(var.vcn_display_name) >= 3
    error_message = "Please provide a valid value for variable VCN Display Name"
  }
}

variable "vcn_cidr_blocks" {
  description = "VCN CIDR Block"
  type        = list(any)
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  type        = string
  validation {
    condition     = length(var.vcn_dns_label) >= 3 && length(var.vcn_dns_label) <= 15
    error_message = "Please provide a valid value for variable VCN DNS Label"
  }
}

variable "igw_display_name" {
  description = "Internet Gateway Display name"
  type        = string
}

variable "igw_enabled" {
  description = "Enable/Disable Internet Gateway"
  type        = bool
}

variable "ngw_display_name" {
  description = "NAT Gateway Display name"
  type        = string
}

variable "srvc_display_name" {
  description = "Service Gateway Display name"
  type        = string
}

variable "route_table_config" {
  type = map(object({
    display_name = string
    route_rules = optional(list(object({
      description          = string
      destination          = string
      destination_type     = string
      network_gateway_type = string
    })))
  }))
}

variable "subnet_config" {
  description = "Subnet config setup object"
  type = map(object({
    subnet_cidr_blocks                = string
    subnet_display_name               = string
    subnet_dns_label                  = string
    subnet_prohibit_internet_ingress  = bool
    subnet_prohibit_public_ip_on_vnic = bool
    route_table_key                   = string
    subnet_security_list = map(object({
      display_name = string
      ingress_rules = optional(list(object({
        description  = string,
        source       = string,
        protocol     = string,
        stateless    = bool,
        src_port_min = optional(number),
        src_port_max = optional(number),
        dst_port_min = optional(number),
        dst_port_max = optional(number),
        icmp_type    = optional(number),
        icmp_code    = optional(number)
      }))),
      egress_rules = optional(list(object({
        description      = string,
        destination      = string,
        destination_type = string,
        protocol         = string,
        stateless        = bool,
        src_port_min     = optional(number),
        src_port_max     = optional(number),
        dst_port_min     = optional(number),
        dst_port_max     = optional(number),
        icmp_type        = optional(number),
        icmp_code        = optional(number)
      })))
    }))
  }))
}

variable "oke_cluster_config" {
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

variable "oke_node_config" {
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

variable "mysql_db_config" {
  description = "MySQL DB configuration"
  type = object({
    mysql_shape_name            = string
    mysql_db_admin_user_name    = string
    mysql_db_secret_name        = string
    mysql_db_sys_desc           = string
    mysql_db_sys_disp_name      = string
    mysql_db_sys_hostname_label = string
    mysql_db_system_ha          = bool
    mysql_db_ver                = string
    mysql_db_sys_port           = string
    mysql_db_sys_port_x         = string
    db_subnet_key               = string
  })
}

variable "bastion_config" {
  description = "Bastion configuration"
  type = map(object({
    bastion_name                 = string
    bastion_type                 = string
    client_cidr_block_allow_list = list(any)
    max_session_ttl_in_seconds   = string
    target_subnet_key            = string
  }))
}

#DevOps setup variables
variable "devops_notifi_topic_name" {
  description = "DevOps Notification Topic Name"
  type        = string
}

variable "devops_notifi_topic_desc" {
  description = "DevOps Notification Topic Description - Topic for events from DevOps activities"
  type        = string
}

variable "devops_prj_name" {
  description = "DevOps Project Name" #Update as needed
  type        = string
}

variable "devops_prj_desc" {
  description = "DevOps Project Description" #Update as needed
  type        = string
}

#DevOps - Artifact Repository
variable "artifact_repo_is_immutable" {
  description = "Artifact Repository Mutable" #Update as needed
  type        = bool
}

variable "artifact_repo_type" {
  description = "Artifact Repository Repository Type" #Update as needed
  type        = string
}

variable "artifact_repo_description" {
  description = "Artifact Repository Description" #Update as needed
  type        = string
}

variable "artifact_repo_display_name" {
  description = "Artifact Repository Display Name" #Update as needed
  type        = string
}

#DevOps Container Registry
variable "container_reg_display_name" {
  description = "Artifact Repository Display Name" #Update as needed
  type        = string
}

variable "container_reg_is_immutable" {
  description = "Artifact Repository Mutable" #Update as needed
  type        = bool
}

variable "container_reg_is_public" {
  description = "Artifact Repository Public/Private" #Update as needed
  type        = bool                                 #Update as needed
}

variable "devops_code_repositories" {
  description = "DevOps Code Repositories object"
  type = map(object({
    repo_name       = string
    repo_type       = string
    repo_dfltbranch = string
    repo_desc       = string
  }))
}