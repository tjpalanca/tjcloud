terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.2"
    }
  }
}

resource "postgresql_database" "keycloak" {
  name = "keycloak"
}

resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

module "keycloak" {
  source       = "../../resources/application"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata.0.name
  service_type = "ClusterIP"
  ports        = [8080]
  replicas     = 1
  command_args = ["start-dev"]
  image        = "quay.io/keycloak/keycloak:${var.keycloak.version}"
  env_vars = {
    DB_VENDOR                = "postgres"
    DB_ADDR                  = var.database.internal_name
    DB_PORT                  = var.database.internal_port
    DB_DATABASE              = "keycloak"
    DB_USER                  = var.database.username
    DB_PASSWORD              = var.database.password
    PROXY_ADDRESS_FORWARDING = "true"
    KEYCLOAK_ADMIN           = var.keycloak.admin.username
    KEYCLOAK_ADMIN_PASSWORD  = var.keycloak.admin.password
  }
}

# module "keycloak_ingress" {
#   source
# }
# apiVersion: networking.k8s.io/v1beta1
# kind: Ingress
# metadata:
#   name: ingress-myservicea
# spec:
#   ingressClassName: nginx
#   rules:
#   - host: myservicea.foo.org
#     http:
#       paths:
#       - path: /
#         backend:
#           serviceName: myservicea
#           servicePort: 80
