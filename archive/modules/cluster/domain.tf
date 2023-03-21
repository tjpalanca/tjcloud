resource "cloudflare_record" "main_node" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = data.linode_instances.main_nodes.instances.0.ip_address
  type    = "A"
  proxied = true
}
