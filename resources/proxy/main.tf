terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }

}

resource "kubernetes_deployment_v1" "proxy" {
  metadata {
    name = "${var.upstream.name}-proxy"
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
