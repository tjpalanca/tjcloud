terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.29.2"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.35.0"
    }
  }
}

locals {
  all_ports = "1-65535"
}

data "tfe_ip_ranges" "ips" {}

resource "linode_firewall" "firewall" {
  label          = var.name
  disabled       = true
  linodes        = var.node_ids
  inbound_policy = "DROP"
  inbound {
    label    = "terraform-cloud"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = local.all_ports
    ipv4     = data.tfe_ip_ranges.ips.api
  }
  inbound {
    label    = "other-whitelisted-ips"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = local.all_ports
    ipv4     = [for ip in var.allowed_ips : "${ip}/32"]
  }
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
