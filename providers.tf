# provider "digitalocean" {
#   token = var.do_token
# }

provider "linode" {
  token = var.linode_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# provider "kubernetes" {
#   host  = module.cluster.cluster.endpoint
#   token = module.cluster.cluster.kube_config.0.token
#   cluster_ca_certificate = base64decode(
#     module.cluster.cluster.kube_config.0.cluster_ca_certificate
#   )
# }
