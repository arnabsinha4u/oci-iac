output "compartment_id" {
  value       = oci_identity_compartment.compartment.id
  description = "Compartment id"
  sensitive   = false
}