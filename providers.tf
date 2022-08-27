# provider "digitalocean" {
#   token = var.do_token
# }

provider "linode" {
  token = var.linode_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  host  = module.cluster.kubeconfig.endpoint
  token = module.cluster.kubeconfig.token
  # cluster_ca_certificate = module.cluster.kubeconfig.cluster_ca_certificate
}
