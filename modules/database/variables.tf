#Variables for MY SQL Database
variable "vcn_id" {
  description = "VCN ID"
  type        = string
}

variable "non_root_compartment_id" {
  description = "Compartment details"
  type        = string
}

variable "mysql_db_system_availability_domain" {
  description = "Availability Domain"
  type        = string
}

variable "mysql_db_conf" {
  description = "MySQL DB configuration"
  type = object({
    mysql_shape_name            = string
    mysql_db_admin_user_name    = string
    mysql_db_secret_name        = string
    mysql_db_sys_desc           = string
    mysql_db_sys_disp_name      = string
    mysql_db_sys_hostname_label = string
    mysql_db_system_ha          = bool
    mysql_db_ver                = string
    mysql_db_sys_port           = string
    mysql_db_sys_port_x         = string
    db_subnet_key               = string
  })
}

variable "network_details" {
  description = "Input network details"
  default     = {}
}