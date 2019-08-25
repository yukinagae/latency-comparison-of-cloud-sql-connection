resource "google_container_node_pool" "primary_preemptible_nodes" {
  project    = var.project
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "compute-rw", "logging-write", "monitoring", # Removed "storage-ro" because we added "-rw" one
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform",
      "storage-rw",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
