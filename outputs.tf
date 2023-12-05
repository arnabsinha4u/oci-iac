output "subnet_network_keys" {
  value       = keys(module.networking.full_subnet_details)
  description = "Subnet Network Key"
  sensitive   = false
}

output "subnet_network_ids" {
  value       = values(module.networking.full_subnet_details)[*].id
  description = "Subnet Network IDs"
  sensitive   = false
}

# WORKING but commented for brivety in output
output "subnet_network_full" {
  value       = module.networking.full_subnet_details
  description = "Subnet Network"
  sensitive   = false
}

output "subnet_keys_names_values_ids" {
  value       = { for k, v in module.networking.subnet_network_name : k => v.id }
  description = "Subnet Network Name and ID looping"
  sensitive   = false
}

output "igw_details" {
  value       = module.networking.igw_details
  description = "IGW Details"
  sensitive   = false
}

output "ngw_details" {
  value       = module.networking.ngw_details
  description = "NAT GW Details"
  sensitive   = false
}

output "sgw_details" {
  value       = module.networking.sgw_details
  description = "Service GW Details"
  sensitive   = false
}

output "route_table_details" {
  value       = module.networking.route_table_details
  description = "Route Table details"
  sensitive   = false
}

output "vault_details" {
  value = module.vault.vault_details
}

output "key_details" {
  value = module.vault.key_details
}

output "secrets_details" {
  value = module.vault.secrets_details
}