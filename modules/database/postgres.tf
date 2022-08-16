module "main_postgres_database" {
  source = "../../resources/postgres"
  database = {
    username   = "tjpalanca"
    password   = var.main_postgres_password
    db_name    = "tjpalanca"
    db_version = "14"
    storage    = "5Gi"
  }
  config = {
    name      = "main"
    namespace = kubernetes_namespace_v1.database.metadata.0.name
  }
}
