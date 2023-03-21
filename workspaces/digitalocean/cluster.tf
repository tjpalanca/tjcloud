resource "digitalocean_kubernetes_cluster" "tjcloud" {
  name          = "tjcloud"
  region        = var.do_region
  version       = "1.25.4-do.0"
  ha            = false
  auto_upgrade  = false
  surge_upgrade = true
  vpc_uuid      = digitalocean_vpc.tjcloud.id

  node_pool {
    name       = "main"
    size       = "s-2vcpu-4gb"
    node_count = 1
  }
}
