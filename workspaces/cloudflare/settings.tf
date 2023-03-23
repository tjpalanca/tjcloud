resource "cloudflare_zone_settings_override" "com_zone" {
  zone_id = var.com_zone_id
  settings {
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    opportunistic_encryption = "on"
    always_use_https         = "on"
    ssl                      = "strict"
    early_hints              = "on"
    rocket_loader            = "on"
    brotli                   = "on"
    cache_level              = "aggressive"
    websockets               = "on"
    opportunistic_onion      = "on"
    pseudo_ipv4              = "add_header"
    ip_geolocation           = "on"
    http3                    = "on"
    max_upload               = 100         # MB
    browser_cache_ttl        = 60 * 60 * 4 # Hours
    minify {
      js   = "on"
      css  = "on"
      html = "on"
    }
  }
}

resource "cloudflare_zone_settings_override" "dev_zone" {
  zone_id = var.dev_zone_id
  settings {
    tls_1_3                  = "on"
    automatic_https_rewrites = "on"
    opportunistic_encryption = "on"
    always_use_https         = "on"
    ssl                      = "strict"
    early_hints              = "on"
    rocket_loader            = "on"
    brotli                   = "on"
    cache_level              = "aggressive"
    websockets               = "on"
    opportunistic_onion      = "on"
    pseudo_ipv4              = "add_header"
    ip_geolocation           = "on"
    http3                    = "on"
    max_upload               = 100         # MB
    browser_cache_ttl        = 60 * 60 * 4 # Hours
    minify {
      js   = "on"
      css  = "on"
      html = "on"
    }
  }
}

resource "cloudflare_record" "dev_zone_root" {
  count   = length(data.tfe_outputs.digitalocean.values.cluster.main_node_ips)
  zone_id = var.dev_zone_id
  name    = "@"
  type    = "A"
  value   = data.tfe_outputs.digitalocean.values.cluster.main_node_ips[count.index]
  proxied = true
}
