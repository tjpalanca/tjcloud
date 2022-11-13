terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.29.2"
    }
  }
}

resource "linode_firewall" "firewall" {
  label           = var.name
  inbound_policy  = "ACCEPT"
  outbound_policy = "ACCEPT"
}
