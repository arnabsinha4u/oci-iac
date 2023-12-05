data "oci_core_services" "service_gateway_services" {
  #Since its Oracle provided services, dependency is not needed
}

data "oci_core_route_tables" "data_route_tables" {
  compartment_id = var.non_root_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  #Explicit dependency added since data is read during the start and these are populated later
  depends_on = [oci_core_vcn.vcn, oci_core_default_route_table.default_route_table,
  oci_core_route_table.route_table]
}