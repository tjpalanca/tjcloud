output "cluster" {
  value = data.digitalocean_kubernetes_cluster.cluster
}

output "nodes" {
  value = data.digitalocean_droplet.nodes
}
