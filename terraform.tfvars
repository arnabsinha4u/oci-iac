#Generic
root_compartment_id         = "ocid1.tenancy.oc1..aaaaaaaave324ybj5a4gs5varksw24nrocqjb72ce7yd6dscoguvlo5lexaa"
environment_name            = "tst"                          #Update per environment
compartment_name            = "non_prod"                     #Environment type, update per environment type e.g. prod
compartment_description     = "NonProduction App - Dev/Test" #Update per environment
base_app_name               = "app"                          #App name like hex
default_availability_domain = "qPqA:EU-Frankfurt-1-AD-1"     #Default AD, Defined as Germany as per Tennet decision
default_region              = "eu-frankfurt-1"               #Default Region, Defined as Germany as per Tennet decision
home_region                 = "eu-amsterdam-1"               #Home Region

#KMS Vault
kms_vault_type = "DEFAULT" #Vault is not virtual private else value can be VIRTUAL_PRIVATE and ONLY 1 vault is created. Avoid multiple vaults. If multiple vaults are there then keys and secrets code has to be modified.
vault_keys_config = {
  master_encryption_key = {
    key_display_name    = "non_prod_app_master_enc_key"
    key_algo            = "AES"
    key_length          = 32
    key_protection_mode = "SOFTWARE" #Protection is not SOFWTARE else can be HSM
  },
}

vault_secrets_config = {
  mysql_db_key = {
    secret_name            = "mysql_db_password"
    secret_content_name    = "mysql_db_password"
    secret_content_type    = "BASE64"
    secret_content_content = "QWRtaW5BUFAxIQ==" # Encoded base64 password included here so that the solution works easily but should never be committed to a source control.
    enc_key                = "master_encryption_key"
  },
}

#VCN Config
vcn_display_name  = "vcn"
vcn_cidr_blocks   = ["10.1.0.0/18"]
vcn_dns_label     = "vcn"
igw_display_name  = "internet_gateway"
igw_enabled       = true
ngw_display_name  = "nat_gateway"
srvc_display_name = "service_gateway"

#Route table config
#Naming convention followed: routetab_ and then the name of the KEY from subnet configuration
route_table_config = {
  routetab_okesrvlb = {
    display_name = "routetab_pub_nw_okesrvlb"
    route_rules = [{
      description          = "Traffic to/from internet"
      destination          = "0.0.0.0/0"
      destination_type     = "CIDR_BLOCK"
      network_gateway_type = "internet"
    }]
  },
  routetab_okeapi = {
    display_name = "routetab_pub_nw_okeapi"
    route_rules = [{
      description          = "Traffic to/from internet"
      destination          = "0.0.0.0/0"
      destination_type     = "CIDR_BLOCK"
      network_gateway_type = "internet"
    }]
  },
  routetab_okenode = {
    display_name = "routetab_pri_nw_okenode"
    route_rules = [{
      description          = "Traffic to/from internet"
      destination          = "0.0.0.0/0"
      destination_type     = "CIDR_BLOCK"
      network_gateway_type = "nat"
      },
      {
        description          = "Traffic to/from internet"
        destination          = "IGNORE-WILL PICK FRA SERVICES since ID 0 is mentioned in Network module"
        destination_type     = "SERVICE_CIDR_BLOCK"
        network_gateway_type = "service"
    }]
  },
  routetab_data = {
    display_name = "routetab_pri_nw_data"
    route_rules = [{
      description          = "Traffic to/from internet"
      destination          = "0.0.0.0/0"
      destination_type     = "CIDR_BLOCK"
      network_gateway_type = "internet"
    }]
  }
}

#Public OKE API and Public OKE Service LB config
subnet_config = {
  subnet_okesrvlb = {
    subnet_cidr_blocks                = "10.1.10.0/28"
    subnet_display_name               = "pub_nw_okesrvlb"
    subnet_dns_label                  = "pubokesvlb"
    subnet_prohibit_internet_ingress  = false
    subnet_prohibit_public_ip_on_vnic = false
    route_table_key                   = "routetab_okesrvlb"
    subnet_security_list = {
      seclist_pub_nw_okesrvlb = {
        display_name = "seclist_pub_nw_okesrvlb"
        ingress_rules = [
          /*
          {
            description = "All ICMP"
            protocol    = "1"
            stateless   = false
            source      = "0.0.0.0/0"
            icmp_type   = 3
            icmp_code   = 4
          }, 
          {
            description  = "SSH"
            protocol     = "6"
            stateless    = false
            source       = "0.0.0.0/0"
            dst_port_min = 22
            dst_port_max = 22
          }, */
          {
            description  = "http"
            protocol     = "6"
            stateless    = false
            source       = "0.0.0.0/0"
            dst_port_min = 80
            dst_port_max = 80
          },
          {
            description  = "https"
            protocol     = "6"
            stateless    = false
            source       = "0.0.0.0/0"
            dst_port_min = 443
            dst_port_max = 443
          },

        ]
        egress_rules = [
          /*
          {
            description      = "All TCP"
            protocol         = "all"
            stateless        = false
            destination      = "0.0.0.0/0"
            destination_type = "CIDR_BLOCK"
          },*/
        ]
      }
    }
  },
  subnet_okeapi = {
    subnet_cidr_blocks                = "10.1.20.0/24"
    subnet_display_name               = "pub_nw_okeapi"
    subnet_dns_label                  = "pubokeapi"
    subnet_prohibit_internet_ingress  = false
    subnet_prohibit_public_ip_on_vnic = false
    route_table_key                   = "routetab_okeapi"
    subnet_security_list = {
      seclist_pub_nw_okeapi = {
        display_name = "seclist_pub_nw_okeapi"
        ingress_rules = [
          {
            description  = "External access to Kubernetes API endpoint"
            protocol     = "6"
            source       = "0.0.0.0/0"
            stateless    = "false"
            dst_port_min = 6443
            dst_port_max = 6443
          },
          {
            description  = "Kubernetes worker to Kubernetes API endpoint communication"
            protocol     = "6"
            source       = "10.1.24.0/21"
            stateless    = "false"
            dst_port_min = 6443
            dst_port_max = 6443
          },
          {
            description  = "Kubernetes worker to control plane communication"
            protocol     = "6"
            source       = "10.1.24.0/21"
            stateless    = "false"
            dst_port_min = 12250
            dst_port_max = 12250
          },
          {
            description = "Path discovery"
            icmp_code   = "4"
            icmp_type   = "3"
            protocol    = "1"
            source      = "10.1.24.0/21"
            stateless   = "false"
          },
        ]
        egress_rules = [
          {
            description      = "Allow Kubernetes Control Plane to communicate with OKE"
            destination      = "all-fra-services-in-oracle-services-network"
            destination_type = "SERVICE_CIDR_BLOCK"
            protocol         = "6"
            stateless        = "false"
            dst_port_min     = 443
            dst_port_max     = 443
          },
          {
            description      = "All traffic to worker nodes"
            destination      = "10.1.24.0/21"
            destination_type = "CIDR_BLOCK"
            protocol         = "6"
            stateless        = "false"
          },
          {
            description      = "Path discovery"
            destination      = "10.1.24.0/21"
            destination_type = "CIDR_BLOCK"
            icmp_code        = "4"
            icmp_type        = "3"
            protocol         = "1"
            stateless        = "false"
          },
        ]
      }
    }
  },
  subnet_okenode = {
    subnet_cidr_blocks                = "10.1.24.0/21"
    subnet_display_name               = "pri_nw_okenode"
    subnet_dns_label                  = "priokenode"
    subnet_prohibit_internet_ingress  = true
    subnet_prohibit_public_ip_on_vnic = true
    route_table_key                   = "routetab_okenode"
    subnet_security_list = {
      seclist_pri_nw_okenode = {
        display_name = "seclist_pri_nw_okenode"
        ingress_rules = [{
          description = "Allow pods on one worker node to communicate with pods on other worker nodes"
          protocol    = "all"
          source      = "10.1.24.0/21"
          stateless   = "false"
          },
          {
            description = "Path discovery"
            icmp_code   = "4"
            icmp_type   = "3"
            protocol    = "1"
            source      = "10.1.20.0/24"
            stateless   = "false"
          },
          {
            description = "TCP access from Kubernetes Control Plane"
            protocol    = "6"
            source      = "10.1.20.0/24"
            stateless   = "false"
          },
          {
            description  = "Inbound SSH traffic to worker nodes"
            protocol     = "6"
            source       = "0.0.0.0/0"
            stateless    = "false"
            dst_port_min = 22
            dst_port_max = 22
          },
        ]
        egress_rules = [
          {
            description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
            destination      = "10.1.20.0/24"
            destination_type = "CIDR_BLOCK"
            protocol         = "all"
            stateless        = "false"
          },
          {
            description      = "Access to Kubernetes API Endpoint"
            destination      = "10.1.20.0/24"
            destination_type = "CIDR_BLOCK"
            protocol         = "6"
            stateless        = "false"
            dst_port_min     = 6443
            dst_port_max     = 6443
          },
          {
            description      = "Kubernetes worker to control plane communication"
            destination      = "10.1.20.0/24"
            destination_type = "CIDR_BLOCK"
            protocol         = "6"
            stateless        = "false"
            dst_port_min     = 12250
            dst_port_max     = 12250
          },
          {
            description      = "Path discovery"
            destination      = "10.1.20.0/24"
            destination_type = "CIDR_BLOCK"
            icmp_code        = "4"
            icmp_type        = "3"
            protocol         = "1"
            stateless        = "false"
          },
          {
            description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
            destination      = "all-fra-services-in-oracle-services-network"
            destination_type = "SERVICE_CIDR_BLOCK"
            protocol         = "6"
            stateless        = "false"
            dst_port_min     = 443
            dst_port_max     = 443
          },
          {
            description      = "ICMP Access from Kubernetes Control Plane"
            destination      = "0.0.0.0/0"
            destination_type = "CIDR_BLOCK"
            icmp_code        = "4"
            icmp_type        = "3"
            protocol         = "1"
            stateless        = "false"
          },
          {
            description      = "Worker Nodes access to Internet" ############### WHY #############
            destination      = "0.0.0.0/0"
            destination_type = "CIDR_BLOCK"
            protocol         = "all"
            stateless        = "false"
          }
        ]
      }
    }
  },
  subnet_data = {
    subnet_cidr_blocks                = "10.1.40.0/28"
    subnet_display_name               = "pri_nw_data"
    subnet_dns_label                  = "pridata"
    subnet_prohibit_internet_ingress  = true
    subnet_prohibit_public_ip_on_vnic = true
    route_table_key                   = "routetab_data"
    subnet_security_list = {
      seclist_pri_nw_data = {
        display_name = "seclist_pri_nw_data"
        ingress_rules = [{
          description  = "Inbound SSH traffic to Database from Bastion"
          protocol     = "6"
          source       = "10.1.40.0/28" #Since Bastion is provisioned in the target subnet
          stateless    = "false"
          dst_port_min = 3306
          dst_port_max = 3306
          },
          {
            description  = "Inbound traffic to Database from OKE Node"
            protocol     = "6"
            source       = "10.1.24.0/21" #From OKE Node
            stateless    = "false"
            dst_port_min = 3306
            dst_port_max = 3306
          },
          {
            description = "Bastion ICMP"
            protocol    = "1"
            source      = "10.1.40.0/28" #Since Bastion is provisioned in the target subnet
            stateless   = "false"
          },
        ]
        egress_rules = [{
          description      = "For Bastion Egress"
          destination      = "10.1.40.0/28" #Since Bastion is provisioned in the target subnet
          destination_type = "CIDR_BLOCK"
          protocol         = "all"
          stateless        = "false"
          },
          {
            description      = "For OKE Node"
            destination      = "10.1.24.0/21" #Since Bastion is provisioned in the target subnet
            destination_type = "CIDR_BLOCK"
            protocol         = "all"
            stateless        = "false"
          },
        ]
      }
    }
  },
}

oke_cluster_config = {
  cluster_name            = "APP_OKE_Cluster"
  oke_version             = "v1.25.4"
  oke_api_subnet_key      = "subnet_okeapi"
  oke_srv_lb_subnet_key   = "subnet_okesrvlb"
  is_pod_security_enabled = false
  is_public_ip_enabled    = true
}

oke_node_config = {
  oke_node_pool_1 = {
    oke_node_pool_name              = "AppCluster-NodePool1"
    oke_node_pool_size              = 1
    oke_node_pool_eviction_duration = "PT30M"
    oke_node_pool_shape_mem_gbs     = 8
    oke_node_pool_shape_ocpu        = 1
    oke_node_pool_shape             = "VM.Standard.E3.Flex"
    oke_node_subnet_key             = "subnet_okenode"
    oke_node_pool_image_id          = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa5sq4dq55pwplfyikmijhegrtyuunwu3uovon6qx6fg2fw2vrrkoq" #ID for Oracle-Linux-8.6-2022.10.04-0-OKE-1.25.4-491
  },
  oke_node_pool_2 = {
    oke_node_pool_name              = "AppCluster-NodePool2"
    oke_node_pool_size              = 1
    oke_node_pool_eviction_duration = "PT10M"
    oke_node_pool_shape_mem_gbs     = 6
    oke_node_pool_shape_ocpu        = 2
    oke_node_pool_shape             = "VM.Standard.E3.Flex"
    oke_node_subnet_key             = "subnet_okenode"
    oke_node_pool_image_id          = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa5sq4dq55pwplfyikmijhegrtyuunwu3uovon6qx6fg2fw2vrrkoq" #ID for Oracle-Linux-8.6-2022.10.04-0-OKE-1.25.4-491
  }
}

#My SQL Database config
mysql_db_config = {
  mysql_shape_name            = "MySQL.VM.Standard.E4.1.8GB"
  mysql_db_admin_user_name    = "adminapp"
  mysql_db_secret_name        = "mysql_db_password"
  mysql_db_sys_desc           = "appdb"
  mysql_db_sys_disp_name      = "App DB"
  mysql_db_sys_hostname_label = "appdb"
  mysql_db_system_ha          = false
  mysql_db_ver                = "8.0.30"
  mysql_db_sys_port           = "3306"
  mysql_db_sys_port_x         = "33060"
  db_subnet_key               = "subnet_data"
}

bastion_config = {
  bastion_mysql_db = {
    bastion_name                 = "Bastion_MySQL_Database"
    bastion_type                 = "standard"
    client_cidr_block_allow_list = ["0.0.0.0/0"]
    max_session_ttl_in_seconds   = "3600" #1 hour
    target_subnet_key            = "subnet_data"
  },
  bastion_oke_node = {
    bastion_name                 = "Bastion_OKE_Node"
    bastion_type                 = "standard"
    client_cidr_block_allow_list = ["0.0.0.0/0"]
    max_session_ttl_in_seconds   = "7200" #2 hours
    target_subnet_key            = "subnet_okenode"
  }
}

#DevOps - Topic
devops_notifi_topic_name = "devops_topic"
devops_notifi_topic_desc = "DevOps Topic"
#DevOps - Project
devops_prj_name = "devops"
devops_prj_desc = "DevOps Project"
#DevOps - Artifact Repository
artifact_repo_is_immutable = true
artifact_repo_type         = "GENERIC"
artifact_repo_description  = "Artifact Repository"
artifact_repo_display_name = "artifact_repository"
#DevOps - Container Registry
container_reg_display_name = "container_registry"
container_reg_is_immutable = false
container_reg_is_public    = false
#Repositories for Infra as Code, UI (as micro frontend), SDK and Business Logic (microservice) created
devops_code_repositories = {
  "iac_repo" = { repo_name = "iac_repo",
    repo_type       = "HOSTED",
    repo_dfltbranch = "main",
  repo_desc = "IaC Repository" },
  "ui_repo" = { repo_name = "ui_repo",
    repo_type       = "HOSTED",
    repo_dfltbranch = "main",
  repo_desc = "UI (Micro-frontend) Repository" },
  "business_logic_repo" = { repo_name = "business_logic_repo",
    repo_type       = "HOSTED",
    repo_dfltbranch = "main",
  repo_desc = "Business Logic (Microservice) Repository" },
  "sdk_repo" = { repo_name = "sdk_repo",
    repo_type       = "HOSTED",
    repo_dfltbranch = "main",
  repo_desc = "SDK Repository" },
}