resource "google_sql_database" "main" {
  project  = var.project
  name     = "database"
  instance = google_sql_database_instance.main.name

  charset   = "utf8mb4"
  collation = "utf8mb4_bin"
}
