#Compartment
variable "non_root_compartment_id" {
  description = "Compartment details"
  type        = string
}

#DevOps Topic
variable "devops_notification_topic_name" {
  description = "DevOps Automation Notification Topic Name"
  type        = string
}

variable "devops_notification_topic_description" {
  description = "DevOps Automation Notification Topic Description"
  type        = string
}

#DevOps Project
variable "devops_project_name" {
  description = "TCS Tennet DevOps Project Name"
  type        = string
}

variable "devops_project_description" {
  description = "TCS Tennet DevOps Project Description"
  type        = string
}

#Artifact Repository
variable "artifact_repository_is_immutable" {
  description = "Artifact Repository Mutable"
  type        = bool
}

variable "artifact_repository_type" {
  description = "Artifact Repository Repository Type"
  type        = string
}

variable "artifact_repository_description" {
  description = "Artifact Repository Description"
  type        = string
}

variable "artifact_repository_display_name" {
  description = "Artifact Repository Display Name"
  type        = string
}

#Container Registry
variable "container_registry_display_name" {
  description = "Artifact Repository Display Name"
  type        = string
}

variable "container_registry_is_immutable" {
  description = "Artifact Repository Mutable"
  type        = bool
}

variable "container_registry_is_public" {
  description = "Artifact Repository Public/Private"
  type        = bool
}

variable "devops_code_repository_setup_config" {
  description = "DevOps Code Repositories object"
  type = map(object({
    repo_name       = string
    repo_type       = string
    repo_dfltbranch = string
    repo_desc       = string
  }))
}