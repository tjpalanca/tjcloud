locals {
  namespace = "database"
}

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
    namespace = local.namespace
  }
}
