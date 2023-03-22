output "cluster" {
  sensitive = true
  value = {
    host  = digitalocean_kubernetes_cluster.tjcloud.endpoint
    token = digitalocean_kubernetes_cluster.tjcloud.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.tjcloud.kube_config[0].cluster_ca_certificate
    )
    main_node_ips = [for ip in digitalocean_reserved_ip.main_nodes : ip.ip_address]
    main_node_ids = [for node in local.main_nodes : node.droplet_id]
  }
}

output "postgres_main" {
  sensitive = true
  value = merge(
    digitalocean_database_cluster.postgres_main,
    data.digitalocean_database_ca.certificates[digitalocean_database_cluster.postgres_main.id]
  )
}

output "mysql_main" {
  sensitive = true
  value = merge(
    digitalocean_database_cluster.mysql_main,
    data.digitalocean_database_ca.certificates[digitalocean_database_cluster.mysql_main.id]
  )
}
