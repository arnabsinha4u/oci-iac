#Create Test Compartment
module "compartment" {
  source = "./modules/compartment"
  providers = {
    oci = oci.home-nl-ams
  }

  root_compartment_id     = var.root_compartment_id
  compartment_name        = "${var.compartment_name}_${var.base_app_name}_${var.environment_name}"
  compartment_description = "${var.compartment_description} - ${var.environment_name}"
}

#Setup KMS-Vault
module "vault" {
  source = "./modules/vault"
  providers = {
    oci = oci.de-fr
  }

  non_root_compartment_id = module.compartment.compartment_id
  kms_vault_display_name  = "${var.compartment_name}_${var.base_app_name}_${var.environment_name}_vault"
  kms_vault_vault_type    = var.kms_vault_type
  kms_vault_keys_conf     = var.vault_keys_config
  vault_secrets_conf      = var.vault_secrets_config
}

#Create VCN, IGW, NGW, SGW and Subnets in Compartment
module "networking" {
  source = "./modules/networking"
  providers = {
    oci = oci.de-fr
  }

  non_root_compartment_id       = module.compartment.compartment_id
  vcn_display_name              = "${var.vcn_display_name}_${var.base_app_name}_${var.environment_name}"
  vcn_cidr_blocks               = var.vcn_cidr_blocks
  vcn_dns_label                 = "${var.vcn_dns_label}${var.base_app_name}${var.environment_name}"
  internet_gateway_display_name = "${var.igw_display_name}_${var.base_app_name}_${var.environment_name}"
  internet_gateway_enabled      = var.igw_enabled
  nat_gateway_display_name      = "${var.ngw_display_name}_${var.base_app_name}_${var.environment_name}"
  service_gateway_display_name  = "${var.srvc_display_name}_${var.base_app_name}_${var.environment_name}"
  route_table_conf              = var.route_table_config
  subnet_data                   = var.subnet_config
}

#Create OKE in Compartment
module "oke_setup" {
  source = "./modules/oke"
  providers = {
    oci = oci.de-fr
  }

  non_root_compartment_id = module.compartment.compartment_id
  vcn_id                  = module.networking.vcn_id
  network_details         = module.networking.full_subnet_details
  oke_cluster_conf        = var.oke_cluster_config
  oke_node_conf           = var.oke_node_config
  depends_on              = [module.networking]
}

#Create MySQL DB in Compartment
module "db_mysql_setup" {
  source = "./modules/database"
  providers = {
    oci = oci.de-fr
  }

  non_root_compartment_id             = module.compartment.compartment_id
  vcn_id                              = module.networking.vcn_id
  mysql_db_system_availability_domain = var.default_availability_domain
  mysql_db_conf                       = var.mysql_db_config
  network_details                     = module.networking.full_subnet_details
  depends_on                          = [module.networking]
}

#Create Bastion in Compartment
module "bastion" {
  source = "./modules/bastion"
  providers = {
    oci = oci.de-fr
  }

  non_root_compartment_id = module.compartment.compartment_id
  network_details         = module.networking.full_subnet_details
  bastion_conf            = var.bastion_config
  depends_on              = [module.networking]
}

#Create DevOps Setup
module "devops_setup" {
  source = "./modules/devops"
  providers = {
    oci = oci.de-fr
  }

  non_root_compartment_id = module.compartment.compartment_id
  #DevOps Topic
  devops_notification_topic_name        = var.devops_notifi_topic_name
  devops_notification_topic_description = var.devops_notifi_topic_desc
  #DevOps Project
  devops_project_name        = var.devops_prj_name
  devops_project_description = var.devops_prj_desc
  #DevOps - Artifact Repository
  artifact_repository_is_immutable = var.artifact_repo_is_immutable
  artifact_repository_type         = var.artifact_repo_type
  artifact_repository_description  = var.artifact_repo_description
  artifact_repository_display_name = var.artifact_repo_display_name
  #DevOps - Container Registry
  container_registry_display_name = var.container_reg_display_name
  container_registry_is_immutable = var.container_reg_is_immutable
  container_registry_is_public    = var.container_reg_is_public

  devops_code_repository_setup_config = var.devops_code_repositories
}