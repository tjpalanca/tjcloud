output "cluster" {
  value = data.digitalocean_kubernetes_cluster.cluster
}

output "node_ips" {
  for_each = data.digitalocean_droplet.nodes
  value    = each.ipv4_address
}
