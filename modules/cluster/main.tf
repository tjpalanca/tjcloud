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

locals {
  node_count = {
    production  = 1
    development = 1
  }
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.cluster_name
  region  = var.do_region
  version = data.digitalocean_kubernetes_versions.versions.latest_version
  node_pool {
    name       = "production"
    size       = "s-2vcpu-4gb"
    node_count = local.node_count.production
    labels = {
      environment = "production"
    }
  }
}

resource "digitalocean_volume" "production" {
  region                  = var.do_region
  name                    = "production"
  size                    = 10
  initial_filesystem_type = "ext4"
}

resource "digitalocean_volume_attachment" "production" {
  droplet_id = digitalocean_kubernetes_cluster.cluster.node_pool.0.nodes.0.droplet_id
  volume_id  = digitalocean_volume.production.id
}

resource "digitalocean_kubernetes_node_pool" "development" {
  cluster_id = digitalocean_kubernetes_cluster.cluster.id
  name       = "development"
  size       = "s-2vcpu-4gb"
  node_count = local.node_count.development
  labels = {
    environment = "development"
  }
}

resource "digitalocean_volume" "development" {
  region                  = var.do_region
  name                    = "development"
  size                    = 40
  initial_filesystem_type = "ext4"
}

resource "digitalocean_volume_attachment" "development" {
  droplet_id = digitalocean_kubernetes_node_pool.development.nodes.0.droplet_id
  volume_id  = digitalocean_volume.development.id
}

data "digitalocean_droplet" "production_nodes" {
  count = local.node_count.production
  name  = digitalocean_kubernetes_cluster.cluster.node_pool.0.nodes[count.index].name
}

data "cloudflare_zone" "main" {
  name = var.main_cloudflare_zone
}

resource "cloudflare_record" "nodes" {
  count   = local.node_count.production
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "@"
  value   = data.digitalocean_droplet.production_nodes[count.index].ipv4_address
  type    = "A"
  proxied = true
  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]
}

resource "digitalocean_firewall" "enable_web_access" {
  name = "k8s-web-access-${digitalocean_kubernetes_cluster.cluster.id}"
  tags = ["k8s:${digitalocean_kubernetes_cluster.cluster.id}"]
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
