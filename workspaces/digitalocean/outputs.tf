output "cluster" {
  sensitive = true
  value = {
    host  = digitalocean_kubernetes_cluster.tjcloud.endpoint
    token = digitalocean_kubernetes_cluster.tjcloud.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.tjcloud.kube_config[0].cluster_ca_certificate
    )
  }
}

output "database_postgres_main" {
  value = digitalocean_database_cluster.postgres_main.id
}

output "database_mysql_main" {
  value = digitalocean_database_cluster.mysql_main.id
}
