terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.29.2"
    }
  }
}

resource "linode_firewall" "firewall" {
  label    = var.name
  linodes  = var.node_ids
  disabled = true
  inbound {
    label    = "other-whitelisted-ips"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = [for ip in var.allowed_ips : "${ip}/32"]
  }
  inbound_policy = "DROP"
  inbound {
    label    = "allow-http-and-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80,443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }
  outbound_policy = "ACCEPT"
}
