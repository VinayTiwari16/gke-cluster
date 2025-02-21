# gke/data.tf
data "terraform_remote_state" "projects" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-vt-cicdproject" # Your GCS bucket
    prefix = "terraform/state"                 # Path to projects state
  }
}

