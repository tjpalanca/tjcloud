resource "digitalocean_database_cluster" "postgres_main" {
  name                 = "postgres-main"
  engine               = "pg"
  version              = "15"
  size                 = "db-s-1vcpu-1gb"
  region               = var.do_region
  private_network_uuid = digitalocean_vpc.tjcloud.id
  node_count           = 1
}

resource "digitalocean_database_cluster" "mysql_main" {
  name                 = "mysql-main"
  engine               = "mysql"
  version              = "8"
  size                 = "db-s-1vcpu-1gb"
  region               = var.do_region
  private_network_uuid = digitalocean_vpc.tjcloud.id
  node_count           = 1
}

resource "digitalocean_database_firewall" "cluster_access" {
  for_each = toset([
    digitalocean_database_cluster.postgres_main.id,
    digitalocean_database_cluster.mysql_main.id
  ])
  cluster_id = each.value
  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.tjcloud.id
  }
}
