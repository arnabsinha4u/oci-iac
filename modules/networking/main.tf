locals {
  all_subnets = flatten([
    for subnet_list_key, subnet_list_value in var.subnet_data : [
      for security_list_key, security_list_value in subnet_list_value.subnet_security_list : {
        subnet_list_key   = subnet_list_key
        security_list_key = security_list_key
        display_name      = security_list_value.display_name
        ingress_rules     = security_list_value.ingress_rules
        egress_rules      = security_list_value.egress_rules
      }
    ]
  ])

  default_security_list_opt = {
    display_name   = "unnamed"
    compartment_id = null
    ingress_rules  = []
    egress_rules   = []
  }
}

resource "oci_core_vcn" "vcn" {
  #Required
  display_name   = var.vcn_display_name
  compartment_id = var.non_root_compartment_id
  cidr_blocks    = var.vcn_cidr_blocks
  dns_label      = var.vcn_dns_label
  freeform_tags = {
    "software_component"     = "vcn"
    "software_sub_component" = "vcn"
    "software_type"          = "network"
  }
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.non_root_compartment_id
  display_name   = var.internet_gateway_display_name
  enabled        = var.internet_gateway_enabled
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.non_root_compartment_id
  display_name   = var.nat_gateway_display_name
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.non_root_compartment_id
  display_name   = var.service_gateway_display_name
  services {
    service_id = data.oci_core_services.service_gateway_services.services.0.id # ID:0 is All FRA Services In Oracle Services Network   
  }
  vcn_id = oci_core_vcn.vcn.id
}

#Creating/Updating default route table as EMPTY
resource "oci_core_default_route_table" "default_route_table" {
  display_name               = "DEFAULT Core Route Table"
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
}

resource "oci_core_route_table" "route_table" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  for_each       = var.route_table_conf
  #Optional
  display_name = each.value.display_name

  dynamic "route_rules" {
    iterator = rule
    for_each = [
      for rr in each.value.route_rules :
      {
        description      = rr.description
        destination      = rr.destination
        destination_type = rr.destination_type
    } if lower(rr.network_gateway_type) == "internet"]

    content {
      description       = rule.value.description
      destination       = rule.value.destination
      destination_type  = rule.value.destination_type
      network_entity_id = oci_core_internet_gateway.internet_gateway.id
    }
  }

  dynamic "route_rules" {
    iterator = rule
    for_each = [
      for rr in each.value.route_rules :
      {
        description      = rr.description
        destination      = rr.destination
        destination_type = rr.destination_type
    } if lower(rr.network_gateway_type) == "nat"]

    content {
      description       = rule.value.description
      destination       = rule.value.destination
      destination_type  = rule.value.destination_type
      network_entity_id = oci_core_nat_gateway.nat_gateway.id
    }
  }

  dynamic "route_rules" {
    iterator = rule
    for_each = [
      for rr in each.value.route_rules :
      {
        description      = rr.description
        destination      = rr.destination
        destination_type = rr.destination_type
    } if lower(rr.network_gateway_type) == "service"]

    content {
      description       = rule.value.description
      destination       = data.oci_core_services.service_gateway_services.services.0.cidr_block # ID:0 is All FRA Services In Oracle Services Network
      destination_type  = rule.value.destination_type
      network_entity_id = oci_core_service_gateway.service_gateway.id
    }
  }
}

#Creating/Updating default security list as EMPTY
resource "oci_core_default_security_list" "default_security_list" {
  compartment_id             = var.non_root_compartment_id
  display_name               = "DEFAULT Core security_list"
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id
}

resource "oci_core_subnet" "subnet_network" {
  #Required
  compartment_id = var.non_root_compartment_id
  vcn_id         = oci_core_vcn.vcn.id

  for_each                   = var.subnet_data
  cidr_block                 = each.value.subnet_cidr_blocks
  display_name               = each.value.subnet_display_name
  dns_label                  = each.value.subnet_dns_label
  prohibit_internet_ingress  = each.value.subnet_prohibit_internet_ingress
  prohibit_public_ip_on_vnic = each.value.subnet_prohibit_public_ip_on_vnic
  security_list_ids          = [for sec_key, sec_val in each.value.subnet_security_list : oci_core_security_list.subnet_security[sec_key].id]
  #route_table_id = oci_core_route_table.route_table["routetab_${each.key}"].id
  route_table_id = oci_core_route_table.route_table[each.value.route_table_key].id
  depends_on = [oci_core_default_route_table.default_route_table,
  oci_core_route_table.route_table]
}

resource "oci_core_security_list" "subnet_security" {
  compartment_id = var.non_root_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  #Optional

  for_each = {
    for subnet_security in local.all_subnets : subnet_security.security_list_key => subnet_security
  }
  display_name = each.value.display_name

  #TCP and ALL protocols with No Ports/Range requirements
  dynamic "ingress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.ingress_rules != null ?
      each.value.ingress_rules : local.default_security_list_opt.ingress_rules :
      {
        proto : sr.protocol
        src : sr.source
        stateless : sr.stateless
        description : sr.description
    } if((sr.protocol == "6" || sr.protocol == "all") && sr.src_port_min == null && sr.src_port_max == null && sr.dst_port_min == null && sr.dst_port_max == null)]

    content {
      protocol    = rule.value.proto
      source      = rule.value.src
      stateless   = rule.value.stateless
      description = rule.value.description
    }
  }

  #TCP with ONLY Destination Ports/Range requirements
  dynamic "ingress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.ingress_rules != null ?
      each.value.ingress_rules : local.default_security_list_opt.ingress_rules :
      {
        proto : sr.protocol
        src : sr.source
        stateless : sr.stateless
        description : sr.description
        dst_port_min : sr.dst_port_min
        dst_port_max : sr.dst_port_max
    } if sr.protocol == "6" && sr.dst_port_min != null && sr.dst_port_max != null]

    content {
      protocol    = rule.value.proto
      source      = rule.value.src
      stateless   = rule.value.stateless
      description = rule.value.description
      tcp_options {
        max = rule.value.dst_port_max
        min = rule.value.dst_port_min
      }
    }
  }

  #ICMP with code and type requirements
  dynamic "ingress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.ingress_rules != null ?
      each.value.ingress_rules : local.default_security_list_opt.ingress_rules :
      {
        proto : sr.protocol
        src : sr.source
        stateless : sr.stateless
        description : sr.description
        icmp_type : sr.icmp_type
        icmp_code : sr.icmp_code
    } if sr.protocol == "1" && sr.icmp_type != null && sr.icmp_code != null]

    content {
      protocol    = rule.value.proto
      source      = rule.value.src
      stateless   = rule.value.stateless
      description = rule.value.description
      icmp_options {
        type = rule.value.icmp_type
        code = rule.value.icmp_code
      }
    }
  }
  #ICMP with NO code and type requirements
  dynamic "ingress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.ingress_rules != null ?
      each.value.ingress_rules : local.default_security_list_opt.ingress_rules :
      {
        proto : sr.protocol
        src : sr.source
        stateless : sr.stateless
        description : sr.description
    } if sr.protocol == "1" && sr.icmp_type == null && sr.icmp_code == null]

    content {
      protocol    = rule.value.proto
      source      = rule.value.src
      stateless   = rule.value.stateless
      description = rule.value.description
    }
  }

  #TCP and ALL protocols with No Ports/Range requirements
  dynamic "egress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.egress_rules != null ?
      each.value.egress_rules : local.default_security_list_opt.egress_rules :
      {
        proto : sr.protocol
        description : sr.description
        dest : sr.destination
        dest_type : sr.destination_type
        stateless : sr.stateless
    } if((sr.protocol == "6" || sr.protocol == "all") && sr.src_port_min == null && sr.src_port_max == null && sr.dst_port_min == null && sr.dst_port_max == null)]

    content {
      protocol         = rule.value.proto
      destination      = rule.value.dest
      destination_type = rule.value.dest_type
      stateless        = rule.value.stateless
      description      = rule.value.description
    }
  }

  #TCP with ONLY Destination Ports/Range requirements
  dynamic "egress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.egress_rules != null ?
      each.value.egress_rules : local.default_security_list_opt.egress_rules :
      {
        proto : sr.protocol
        description : sr.description
        dest : sr.destination
        dest_type : sr.destination_type
        stateless : sr.stateless
        dst_port_min : sr.dst_port_min
        dst_port_max : sr.dst_port_max
    } if sr.protocol == "6" && sr.dst_port_min != null && sr.dst_port_max != null]

    content {
      protocol         = rule.value.proto
      destination      = rule.value.dest
      destination_type = rule.value.dest_type
      stateless        = rule.value.stateless
      description      = rule.value.description
      tcp_options {
        max = rule.value.dst_port_max
        min = rule.value.dst_port_min
      }
    }
  }

  #ICMP with code and type requirements
  dynamic "egress_security_rules" {
    iterator = rule
    for_each = [
      for sr in each.value.egress_rules != null ?
      each.value.egress_rules : local.default_security_list_opt.egress_rules :
      {
        proto : sr.protocol
        description : sr.description
        dest : sr.destination
        dest_type : sr.destination_type
        stateless : sr.stateless
        icmp_type : sr.icmp_type
        icmp_code : sr.icmp_code
    } if sr.protocol == "1" && sr.icmp_type != null && sr.icmp_code != null]

    content {
      protocol         = rule.value.proto
      destination      = rule.value.dest
      destination_type = rule.value.dest_type
      stateless        = rule.value.stateless
      description      = rule.value.description
      icmp_options {
        type = rule.value.icmp_type
        code = rule.value.icmp_code
      }
    }
  }
}