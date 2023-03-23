resource "digitalocean_firewall" "cloudflare" {
  name        = "tjcloud-cloudflare"
  droplet_ids = data.tfe_outputs.digitalocean.values.cluster.main_node_ids
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
  }
}
