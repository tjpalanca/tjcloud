resource "digitalocean_vpc" "tjcloud" {
  name        = "tjcloud"
  description = "Cloud Workspace VPC"
  region      = var.do_region
}

resource "digitalocean_reserved_ip" "main_nodes" {
  count  = length(local.main_nodes)
  region = var.do_region
}

resource "digitalocean_reserved_ip_assignment" "main_nodes" {
  count      = length(local.main_nodes)
  droplet_id = local.main_nodes[count.index].droplet_id
  ip_address = digitalocean_reserved_ip.main_nodes[count.index].id
}
