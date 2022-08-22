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
  region  = var.do_region
  version = data.digitalocean_kubernetes_versions.versions.latest_version
  node_pool {
    name       = "default"
    size       = "s-2vcpu-4gb"
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

data "cloudflare_zone" "main" {
  name = var.main_cloudflare_zone
}

resource "cloudflare_record" "nodes" {
  for_each = data.digitalocean_droplet.nodes
  zone_id  = data.cloudflare_zone.main.zone_id
  name     = "@"
  value    = each.value.ipv4_address
  type     = "A"
  proxied  = true
  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]
}

resource "digitalocean_firewall" "enable_web_access" {
  name = "k8s-web-access-${data.digitalocean_kubernetes_cluster.cluster.id}"
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
  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]
}
