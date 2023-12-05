resource "oci_ons_notification_topic" "devops_notification_topic" {
  #Required
  compartment_id = var.non_root_compartment_id
  name           = var.devops_notification_topic_name

  #Optional
  description = var.devops_notification_topic_description
  freeform_tags = {
    "software_component"     = "topic"
    "software_sub_component" = "storage"
    "software_type"          = "automation"
  }
}

resource "oci_devops_project" "devops_project" {
  #Required
  name           = var.devops_project_name
  compartment_id = var.non_root_compartment_id
  notification_config {
    #Required
    topic_id = oci_ons_notification_topic.devops_notification_topic.id
  }

  #Optional
  description = var.devops_project_description

  freeform_tags = {
    "software_component"     = "project"
    "software_sub_component" = "none"
    "software_type"          = "development, automation"
  }
}

resource "oci_artifacts_repository" "devops_artifact_repository" {
  #Required
  compartment_id  = var.non_root_compartment_id
  is_immutable    = var.artifact_repository_is_immutable
  repository_type = var.artifact_repository_type

  #Optional
  description  = var.artifact_repository_description
  display_name = var.artifact_repository_display_name
}

resource "oci_artifacts_container_repository" "devops_container_registry" {
  #Required
  compartment_id = var.non_root_compartment_id
  display_name   = var.container_registry_display_name

  #Optional
  is_immutable = var.container_registry_is_immutable
  is_public    = var.container_registry_is_public
}

resource "oci_devops_repository" "code_repository_setup" {
  project_id      = oci_devops_project.devops_project.id
  for_each        = var.devops_code_repository_setup_config
  name            = each.value.repo_name
  repository_type = each.value.repo_type
  default_branch  = each.value.repo_dfltbranch
  description     = each.value.repo_desc
  freeform_tags = {
    "software_component"     = "repository"
    "software_sub_component" = "none"
    "software_type"          = "development, automation"
  }
}