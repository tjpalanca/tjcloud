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

data "tfe_ip_ranges" "ips" {}

locals {
  allowed_ips = concat(var.allowed_ips, data.tfe_ip_ranges.ips.api)
}

resource "linode_firewall" "firewall" {
  label          = var.name
  disabled       = true
  inbound_policy = "DROP"
  inbound {
    label    = "terraform-cloud"
    action   = "ACCEPT"
    protocol = "TCP"
    ipv4     = data.tfe_ip_ranges.ips.api
  }
  inbound {
    label    = "other-whitelisted-ips"
    action   = "ACCEPT"
    protocol = "TCP"
    ipv4     = var.allowed_ips
  }
  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
  }
  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
  }
  outbound_policy = "ACCEPT"
}
