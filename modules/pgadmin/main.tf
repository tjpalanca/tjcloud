terraform {
  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "2.12.1"
  }
}

resource "kubernetes_namespace_v1" "pgadmin" {
  metadata {
    name = "pgadmin"
  }
}

resource "kubernetes_deployment_v1" "pgadmin" {
  metadata {
    name      = "pgadmin"
    namespace = kubernetes_namespace_v1.pgadmin.metadata.0.name
  }
  spec {
    replicas = 1
    template {
      spec {
        container {
          name  = "pgadmin"
          image = "docker pull dpage/pgadmin4:6.12"
          port  = 5050
          env {
            name  = "PGADMIN_DEFAULT_EMAIL"
            value = var.pgadmin_default_username
          }
          env {
            name  = "PGADMIN_DEFAULT_PASSWORD"
            value = var.pgadmin_default_password
          }
          env {
            name  = "PGADMIN_LISTEN_ADDRESS"
            value = "0.0.0.0"
          }
          env {
            name  = "PGADMIN_LISTEN_PORT"
            value = "5050"
          }
          env {
            name  = "PGADMIN_CONFIG_SERVER_MODE"
            value = "True"
          }
        }
      }
    }
  }
}
