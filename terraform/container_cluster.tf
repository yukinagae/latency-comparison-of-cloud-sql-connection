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

  ip_allocation_policy {
    create_subnetwork = true
    subnetwork_name   = "my-gke-cluster-sub-network"
  }

  network = google_compute_network.private_network.self_link

  master_auth {
    username = "gke-master-user"
    password = random_string.gke_master_password.result

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "allow_all"
      cidr_block   = "0.0.0.0/0"
    }
  }
}

resource "random_string" "gke_master_password" {
  length  = 16
  special = false
}
