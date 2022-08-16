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

data "digitalocean_kubernetes_versions" "versions" {
  version_prefix = "1.23."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.cluster_name
  region  = "sgp1"
  version = data.digitalocean_kubernetes_versions.versions.latest_version
  node_pool {
    name       = "worker-pool"
    size       = "s-4vcpu-8gb"
    node_count = 1
  }
}

data "digitalocean_kubernetes_cluster" "cluster" {
  name = var.cluster_name
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
