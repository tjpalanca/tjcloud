terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud"
    }
  }
}

module "cluster" {
  source          = "./modules/cluster"
  cluster_name    = var.cluster_name
  cloudflare_zone = var.main_cloudflare_zone
  linode_region   = var.linode_region
  root_password   = var.root_password
  linode_token    = var.linode_token
  local_ssh_key   = var.local_ssh_key
}

module "database" {
  source                    = "./modules/database"
  main_postgres_username    = var.main_postgres_username
  main_postgres_database    = var.main_postgres_database
  main_postgres_password    = var.main_postgres_password
  main_postgres_node_name   = module.cluster.main_node.label
  main_postgres_volume_name = module.cluster.main_node_volume.label
  depends_on = [
    module.cluster
  ]
}

module "ingress" {
  source = "./modules/ingress"
  depends_on = [
    module.cluster
  ]
}

# module "pgadmin" {
#   source                   = "./modules/pgadmin"
#   pgadmin_default_username = var.pgadmin_default_username
#   pgadmin_default_password = var.pgadmin_default_password
#   depends_on = [
#     module.cluster.cluster
#   ]
# }
