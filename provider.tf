terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.21.0"
    }
  }
}

provider "google" {
  #credentials = file(var.credentials_file) # Path to your GCP service account key file
  project = local.project_id
  region  = var.region
}


terraform {
  backend "gcs" {
    bucket = "terraform-state-vt-cicdproject"
    prefix = "gke-cluster/state"
  }
}