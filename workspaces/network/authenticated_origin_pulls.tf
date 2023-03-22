resource "cloudflare_authenticated_origin_pulls" "dev_zone" {
  zone_id = var.dev_zone_id
  enabled = true
}

resource "kubernetes_secret_v1" "authenticated_origin_pull_ca" {
  metadata {
    name      = "authenticated-origin-pull-ca"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }
  data = {
    "ca.crt" = file("${path.module}/authenticated_origin_pull_ca.pem")
  }
}
