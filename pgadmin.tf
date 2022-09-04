resource "kubernetes_namespace_v1" "pgadmin" {
  metadata {
    name = "pgadmin"
  }
}

module "pgadmin_application" {
  source    = "./modules/application"
  name      = "pgadmin"
  namespace = kubernetes_namespace_v1.pgadmin.metadata[0].name
  ports     = [5050]
  image     = "dpage/pgadmin4:6.12"
  env_vars = {
    PGADMIN_DEFAULT_EMAIL      = var.pgadmin_default_username
    PGADMIN_DEFAULT_PASSWORD   = var.pgadmin_default_password
    PGADMIN_LISTEN_ADDRESS     = "0.0.0.0"
    PGADMIN_LISTEN_PORT        = "5050"
    PGADMIN_CONFIG_SERVER_MODE = "True"
  }
}
