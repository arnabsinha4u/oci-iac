#Variables for VCN
variable "vcn_display_name" {
  description = "VCN Display Name"
  type        = string
}

variable "non_root_compartment_id" {
  description = "Compartment details"
  type        = string
}

variable "vcn_cidr_blocks" {
  description = "VCN CIDR Block"
  type        = list(any)
}

variable "vcn_dns_label" {
  description = "DNS Label Name"
  type        = string
}

variable "internet_gateway_display_name" {
  description = "Internet Gateway Display name"
  type        = string
}

variable "internet_gateway_enabled" {
  description = "Enable/Disable Internet Gateway"
  type        = bool
}

variable "nat_gateway_display_name" {
  description = "NAT Gateway Display name"
  type        = string
}

variable "service_gateway_display_name" {
  description = "Service Gateway Display name"
  type        = string
}

variable "route_table_conf" {
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

variable "subnet_data" {
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