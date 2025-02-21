# Use the project_id from the remote state
locals {
  project_id = data.terraform_remote_state.projects.outputs.project_id
}

# Enable required APIs
resource "google_project_service" "gke_apis" {
  for_each = toset(var.apis_to_enable)
  project = local.project_id
  service = each.key
}

# Create GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = local.project_id

# Enable Workload Identity at the cluster level
  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

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
    service_account = google_service_account.gke_node.email

    # Enable workload identity (recommended)
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

 # Ensure Workload Identity is enabled before creating the cluster
  depends_on = [
    google_project_service.gke_apis
  ]
}


# Create a service account for GKE nodes
resource "google_service_account" "gke_node" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
}

# Grant the service account necessary permissions
resource "google_project_iam_member" "gke_node" {
  project = local.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}