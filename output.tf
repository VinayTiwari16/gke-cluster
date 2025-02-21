output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Endpoint for accessing the cluster"
  value       = google_container_cluster.primary.endpoint
}

output "kubeconfig" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${local.project_id}"
  sensitive   = true
}