resource "random_password" "tunnel_secret" {
  length = 32
}

resource "cloudflare_tunnel" "tjcloud" {
  account_id = var.cloudflare_account_id
  name       = "tjcloud"
  secret     = base64encode(random_password.tunnel_secret.result)
}

module "cloudflare_namespace" {
  source = "../../modules/namespace"
  name   = "cloudflare"
}

module "cloudflare_tunnel_deployment" {
  source    = "../../modules/deployment"
  name      = "tunnel"
  namespace = module.cloudflare_namespace.name
  image     = "cloudflare/cloudflared:latest"
  replicas  = 2
  args      = ["tunnel", "--no-autoupdate", "--metrics", "0.0.0.0:8081", "run"]
  env_vars = {
    TUNNEL_TOKEN = cloudflare_tunnel.tjcloud.tunnel_token
    TZ           = "UTC"
  }
  liveness_probes = [{
    path                  = "/ready"
    port                  = 8081
    initial_delay_seconds = 10
    period_seconds        = 10
    failure_threshold     = 3
  }]
  ports = [8081]
}
