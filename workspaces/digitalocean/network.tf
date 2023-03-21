resource "digitalocean_vpc" "tjcloud" {
  name        = "tjcloud"
  description = "Cloud Workspace VPC"
  region      = var.do_region
}

resource "digitalocean_reserved_ip" "main_nodes" {
  count  = length(digitalocean_kubernetes_cluster.tjcloud.node_pool[0].nodes)
  region = var.do_region
}

resource "digitalocean_reserved_ip_assignment" "main_nodes" {
  count      = length(digitalocean_kubernetes_cluster.tjcloud.node_pool[0].nodes)
  droplet_id = digitalocean_kubernetes_cluster.tjcloud.node_pool[0].nodes[count.index].droplet_id
  ip_address = digitalocean_reserved_ip.main_nodes[count.index].id
}
