terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

module "proxy_application" {
  source       = "../application"
  name         = "${var.upstream.name}-proxy"
  namespace    = var.upstream.namespace
  service_type = "ClusterIP"
  ports        = [4180]
  replicas     = 1
  command_args = ["start-dev"]
  image        = var.keycloak.image
  env_vars = {
    KC_DB                   = "postgres"
    KC_DB_URL_HOST          = var.database.internal_name
    KC_DB_URL_PORT          = var.database.internal_port
    KC_DB_URL_DATABASE      = postgresql_database.keycloak.name
    KC_DB_USERNAME          = var.database.username
    KC_DB_PASSWORD          = var.database.password
    KEYCLOAK_ADMIN          = var.admin.username
    KEYCLOAK_ADMIN_PASSWORD = var.admin.password
    KC_PROXY                = "edge"
  }
}

resource "kubernetes_deployment_v1" "proxy" {
  metadata {
    name = 
  }
  spec {
    replicas = 1
    template {
      spec {
        container {
          name  = "oauth2-proxy"
          image = "quay.io/oauth2-proxy/oauth2-proxy:v7.2.0"
          port  = var.config.port
          env {
            OAUTH2_PROXY_UPSTREAMS              = var.upstream.addr
            OAUTH2_PROXY_CLIENT_ID              = var.config.keycloak_client_id
            OAUTH2_PROXY_CLIENT_SECRET          = var.config.keycloak_client_secret
            OAUTH2_PROXY_ALLOWED_GROUPS         = var.config.keycloak_allowed_groups
            OAUTH2_PROXY_REVERSE_PROXY          = "true"
            OAUTH2_PROXY_REAL_CLIENT_IP_HEADER  = "X-Forwarded-For"
            OAUTH2_PROXY_SESSION_COOKIE_MINIMAL = "true"
            OAUTH2_PROXY_COOKIE_EXPIRE          = "168h0m0s"
            OAUTH2_PROXY_COOKIE_NAME            = "_${var.upstream.name}_oauth2_proxy"
            OAUTH2_PROXY_COOKIE_SECRET          = var.config.cookie_secret
            OAUTH2_PROXY_EMAIL_DOMAINS          = var.config.email_domains
            OAUTH2_PROXY_HTTP_ADDRESS           = "0.0.0.0:${var.config.port}"
            OAUTH2_PROXY_PROVIDER               = "keycloak-oidc"
            OAUTH2_PROXY_OIDC_ISSUER_URL        = "https://${var.config.keycloak_domain}/auth/realms/master"
            OAUTH2_PROXY_SKIP_PROVIDER_BUTTON   = "true"
          }
        }
      }
    }
  }
}
