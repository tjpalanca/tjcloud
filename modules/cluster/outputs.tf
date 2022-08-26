output "cluster" {
  value = digitalocean_kubernetes_cluster.cluster
}

output "urns" {
  value = [
    digitalocean_kubernetes_cluster.cluster.urn,
    digitalocean_volume.production.urn,
    digitalocean_volume.development.urn
  ]
}
