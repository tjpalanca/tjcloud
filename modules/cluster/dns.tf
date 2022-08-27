data "cloudflare_zone" "main" {
  name = var.main_cloudflare_zone
}

resource "cloudflare_record" "production_nodes" {
  count   = local.node_count
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "@"
  value   = data.linode_instances.production_nodes[count.index].instances.0.ip_address
  type    = "A"
  proxied = true
  depends_on = [
    linode_lke_cluster.cluster
  ]
}
