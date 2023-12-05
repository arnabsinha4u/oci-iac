output "vcn_id" {
  value       = oci_core_vcn.vcn.id
  description = "VCN id"
  sensitive   = false
}

output "igw_id" {
  value       = oci_core_internet_gateway.internet_gateway.id
  description = "IGW id"
  sensitive   = false
}

output "ngw_id" {
  value       = oci_core_nat_gateway.nat_gateway.id
  description = "NAT GW id"
  sensitive   = false
}

output "sgw_id" {
  value       = oci_core_service_gateway.service_gateway.id
  description = "Service GW id"
  sensitive   = false
}

output "igw_details" {
  value       = oci_core_internet_gateway.internet_gateway
  description = "IGW details"
  sensitive   = false
}

output "ngw_details" {
  value       = oci_core_nat_gateway.nat_gateway
  description = "NAT GW details"
  sensitive   = false
}

output "sgw_details" {
  value       = oci_core_service_gateway.service_gateway
  description = "Service GW details"
  sensitive   = false
}

output "route_table_details" {
  value       = oci_core_route_table.route_table
  description = "Route Table details"
  sensitive   = false
}

output "subnet_network_id" {
  value       = { for s in oci_core_subnet.subnet_network : s.id => s }
  description = "Subnet Network ID"
  sensitive   = false
}

output "subnet_network_name" {
  value       = { for s in oci_core_subnet.subnet_network : s.display_name => s }
  description = "Subnet Network Name"
  sensitive   = false
}

output "full_subnet_details" {
  value       = oci_core_subnet.subnet_network
  description = "FULL Subnet Network details"
  sensitive   = false
}