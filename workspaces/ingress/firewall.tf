resource "digitalocean_firewall" "ingress" {
  name        = "tjcloud-ingress"
  droplet_ids = data.tfe_outputs.digitalocean.values.cluster.main_node_ids

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}
