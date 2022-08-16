output "cluster" {
  value = data.digitalocean_kubernetes_cluster.cluster
}

output "node_ips" {
  value = [
    for name, props in data.digitalocean_droplet.nodes :
    props.ipv4_address
  ]
}
