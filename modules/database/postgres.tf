module "main_postgres_database" {
  source = "../../resources/postgres"
  database = {
    username   = var.main_postgres_username
    password   = var.main_postgres_password
    db_name    = var.main_postgres_database
    db_version = "14"
    storage    = "3Gi"
  }
  config = {
    name      = "main"
    namespace = kubernetes_namespace_v1.database.metadata.0.name
  }
}
