resource "google_sql_database_instance" "main" {
  project          = var.project
  name             = "yukinagae-${random_id.sql_database_suffix.hex}"
  database_version = "MYSQL_5_7"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    disk_type = "PD_HDD"
    disk_size = "10"

    location_preference {
      zone = "us-central1-a"
    }

    # ip_configuration {
    #   ipv4_enabled = "true"
    #   require_ssl = "false"
    #   private_network = "${var.vpc_self_link}"
    # }

    database_flags {
      name  = "log_output"
      value = "FILE"
    }
    database_flags {
      name  = "general_log"
      value = "on"
    }
    database_flags {
      name  = "slow_query_log"
      value = "on"
    }
  }

  depends_on = [random_id.sql_database_suffix]
}

resource "random_id" "sql_database_suffix" {
  byte_length = 8
}