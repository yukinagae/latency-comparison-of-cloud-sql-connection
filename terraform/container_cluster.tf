resource "google_container_cluster" "primary" {
  project  = var.project
  name     = "my-gke-cluster"
  location = "us-central1-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  master_auth {
    username = "gke-master-user"
    password = random_string.gke_master_password.result

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "random_string" "gke_master_password" {
  length  = 16
  special = false
}
