variable "credentials_file" {
  description = "Path to GCP service account key file"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "my-gke-cluster"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_disk_size_gb" {
  description = "Disk size for GKE nodes (GB)"
  type        = number
  default     = 30
}

variable "apis_to_enable" {
  description = "List of APIs to enable in the project"
  type        = list(string)
  default     = ["compute.googleapis.com", "storage.googleapis.com"]
}