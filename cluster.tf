module "cluster" {
  source          = "./modules/cluster"
  cluster_name    = var.cluster_name
  cloudflare_zone = var.main_cloudflare_zone
  linode_region   = var.linode_region
  root_password   = var.root_password
  linode_token    = var.linode_token
  local_ssh_key   = var.local_ssh_key
}
