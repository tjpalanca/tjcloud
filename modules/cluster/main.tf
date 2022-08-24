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
    node_count = 1
    taint {
      key    = "environment"
      value  = "development"
      effect = "NoExecute"
    }
  }
}

resource "digitalocean_kubernetes_node_pool" "development" {
  cluster_id = digitalocean_kubernetes_cluster.cluster.id
  name       = "development"
  size       = "s-2vcpu-4gb"
  node_count = local.node_count.development
  taint {
    key    = "environment"
    value  = "production"
    effect = "NoExecute"
  }
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
