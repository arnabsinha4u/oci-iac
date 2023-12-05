# Terraform
terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "5.20.0"
    }
  }
}

provider "oci" {
  alias  = "home-nl-ams"
  region = var.home_region
}

provider "oci" {
  alias  = "de-fr"
  region = var.default_region
}
