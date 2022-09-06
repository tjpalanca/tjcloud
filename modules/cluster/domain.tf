data "cloudflare_zone" "main" {
  name = var.cloudflare_zone
}

resource "cloudflare_record" "main_node" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "@"
  value   = data.linode_instances.main_nodes.instances.0.ip_address
  type    = "A"
  proxied = true
}

resource "cloudflare_zone_settings_override" "overrides" {
  zone_id = data.cloudflare_zone.main.zone_id
  settings {
    cache_level = "basic"
  }
}
