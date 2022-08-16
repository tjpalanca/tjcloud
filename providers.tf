provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.tjcloud.endpoint
  token = data.digitalocean_kubernetes_cluster.tjcloud.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.tjcloud.kube_config[0].cluster_ca_certificate
  )
}
