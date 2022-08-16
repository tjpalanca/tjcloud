terraform {

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

}

locals {
  cluster_name = "tjcloud"
}

data "digitalocean_kubernetes_versions" "versions" {
  version_prefix = "1.23."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = local.cluster_name
  region  = "sgp1"
  version = data.digitalocean_kubernetes_versions.versions.latest_version
  node_pool {
    name       = "worker-pool"
    size       = "s-4vcpu-8gb"
    node_count = 1
  }
}

data "digitalocean_kubernetes_cluster" "cluster" {
  name = local.cluster_name
}

data "digitalocean_droplet" "nodes" {
  for_each = toset([
    for node in data.digitalocean_kubernetes_cluster.cluster.node_pool.0.nodes :
    node.name
  ])
  name = each.value
}

data "cloudflare_zone" "tjp_app" {
  name = "tjp.app"
}

resource "cloudflare_record" "nodes" {
  for_each = data.digitalocean_droplet.nodes
  zone_id  = data.cloudflare_zone.tjp_app.zone_id
  name     = "@"
  value    = each.value.ipv4_address
  type     = "A"
  proxied  = true
}

resource "digitalocean_firewall" "enable_web_access" {
  name = "k8s-${data.digitalocean_kubernetes_cluster.cluster.id}-web-access"
  tags = ["k8s:${data.digitalocean_kubernetes_cluster.cluster.id}"]
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
