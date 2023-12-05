output "topic_id" {
  value       = oci_ons_notification_topic.devops_notification_topic.id
  description = "DevOps and Automation Notification Topic ID"
  sensitive   = false
}

output "project_id" {
  value       = oci_devops_project.devops_project.id
  description = "DevOps and Automation Notification Project ID"
  sensitive   = false
}