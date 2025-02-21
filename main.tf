# Use the project_id from the remote state
locals {
  project_id = data.terraform_remote_state.projects.outputs.project_id
}

# Enable required APIs
resource "google_project_service" "gke_apis" {
  project = local.project_id
  service = "container.googleapis.com"
}

# Create GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Use the default VPC and subnet (auto-created by GCP)
  network    = "default"
  subnetwork = "default"

  # Basic configuration
  initial_node_count = 1
  deletion_protection = false # Set to "true" for production

  # Node pool configuration
  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb

    # Use the default service account for simplicity (not recommended for production)
    service_account = "default"

    # Enable workload identity (recommended)
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Ensure APIs are enabled before creating the cluster
  depends_on = [google_project_service.gke_apis]
}