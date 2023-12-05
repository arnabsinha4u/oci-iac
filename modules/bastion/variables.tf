variable "non_root_compartment_id" {
  description = "Compartment details"
  type        = string
}

variable "bastion_conf" {
  description = "Bastion configuration"
  type = map(object({
    bastion_name                 = string
    bastion_type                 = string
    client_cidr_block_allow_list = list(any)
    max_session_ttl_in_seconds   = string
    target_subnet_key            = string
  }))
}

variable "network_details" {
  description = "Input network details"
  default     = {}
}
