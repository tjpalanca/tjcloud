resource "random_password" "tunnel_secret" {
  length = 32
}

resource "cloudflare_tunnel" "tjcloud" {
  account_id = var.cloudflare_account_id
  name       = "tjcloud"
  secret     = base64encode(random_password.tunnel_secret.result)
}

resource "kubernetes_namespace_v1" "cloudflare" {
  metadata {
    name = "cloudflare"
  }
}

resource "kubernetes_deployment_v1" "tunnel" {
  metadata {
    name      = "tunnel"
    namespace = kubernetes_namespace_v1.cloudflare.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        tunnel = cloudflare_tunnel.tjcloud.name
      }
    }
    strategy {
      rolling_update {
        max_surge       = 2
        max_unavailable = 1
      }
    }
    template {
      metadata {
        labels = {
          tunnel = cloudflare_tunnel.tjcloud.name
        }
      }
      spec {
        container {
          name = "tunnel"
          args = [
            "tunnel",
            "--no-autoupdate",
            "--metrics", "0.0.0.0:8081",
            "run"
          ]
          env {
            name  = "TUNNEL_TOKEN"
            value = cloudflare_tunnel.tjcloud.tunnel_token
          }
          env {
            name  = "TZ"
            value = "UTC"
          }
          image             = "cloudflare/cloudflared:latest"
          image_pull_policy = "Always"
          liveness_probe {
            failure_threshold = 3
            http_get {
              path = "/ready"
              port = 8081
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
          port {
            container_port = 8081
            name           = "http-metrics"
          }
        }
      }
    }
  }
}
