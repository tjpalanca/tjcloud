data "cloudflare_ip_ranges" "cloudflare" {}

resource "kubernetes_config_map_v1" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
    labels = merge(local.labels, {
      "app.kubernetes.io/component" = "controller"
    })
  }
  data = {
    allow-snippet-annotations = "true"
    "proxy-real-ip-cidr"      = join(",", data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks)
    "use-forwarded-headers"   = "true"
    "forwarded-for-header"    = "CF-Connecting-IP"
    "server-snippet"          = <<EOF
      location /.well-known/webfinger {
        return 301 https://mastodon.${var.cloudflare_zone_name}$request_uri;
      }
    EOF
  }
}

resource "kubernetes_secret_v1" "ca_secret" {
  metadata {
    name      = "ca-secret"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }
  data = {
    "ca.crt" = file("${path.module}/authenticated_origin_pull_ca.pem")
  }
}
