resource "oci_mysql_mysql_db_system" "mysql_db" {
  #Required
  compartment_id      = var.non_root_compartment_id
  subnet_id           = var.network_details[var.mysql_db_conf.db_subnet_key].id
  availability_domain = var.mysql_db_system_availability_domain
  shape_name          = var.mysql_db_conf.mysql_shape_name
  admin_username      = var.mysql_db_conf.mysql_db_admin_user_name
  admin_password      = base64decode(data.oci_secrets_secretbundle.secret_bundle.secret_bundle_content.0.content)
  description         = var.mysql_db_conf.mysql_db_sys_desc
  display_name        = var.mysql_db_conf.mysql_db_sys_disp_name
  hostname_label      = var.mysql_db_conf.mysql_db_sys_hostname_label
  is_highly_available = var.mysql_db_conf.mysql_db_system_ha
  mysql_version       = var.mysql_db_conf.mysql_db_ver
  port                = var.mysql_db_conf.mysql_db_sys_port
  port_x              = var.mysql_db_conf.mysql_db_sys_port_x
}