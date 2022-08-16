output "cluster" {
  value = {
    urn         = digitalocean_kubernetes_cluster.tjcloud.urn
    endpoint    = digitalocean_kubernetes_cluster.tjcloud.endpoint
    kube_config = digitalocean_kubernetes_cluster.tjcloud.kube_config
  }
}
