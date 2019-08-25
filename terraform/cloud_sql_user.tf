resource "google_sql_user" "proxy" {
  project  = var.project
  name     = "proxyuser"
  instance = google_sql_database_instance.main.name
  host     = "cloudsqlproxy~%"
}

resource "google_sql_user" "root" {
  project  = var.project
  name     = "root"
  instance = google_sql_database_instance.main.name
  host     = "%"
  password = random_string.root_password.result
}

output "sql_password_root" {
  value = random_string.root_password.result
}

resource "random_string" "root_password" {
  length = 16
}
