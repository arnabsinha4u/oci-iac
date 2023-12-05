resource "oci_identity_compartment" "compartment" {
  #Required
  compartment_id = var.root_compartment_id
  description    = var.compartment_description
  name           = var.compartment_name

  #Optional
  freeform_tags = {
    "software_component"     = "compartment"
    "software_sub_component" = "none"
    "software_type"          = "setup, automation"
  }
}
