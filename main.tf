terraform {

  required_providers {

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }

  }

  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud"
    }
  }

}

provider "digitalocean" {
  token = var.do_token
}

module "cluster" {
  source       = "./modules/cluster"
  cluster_name = var.cluster_name
}

resource "digitalocean_project" "tjcloud" {
  name        = "TJCloud"
  description = "TJ Palanca's Personal Cloud"
  purpose     = "Machine learning / AI / Data processing"
  environment = "Production"
  resources = [
    module.cluster.cluster_urn
  ]
}

data "digitalocean_kubernetes_cluster" "tjcloud" {
  name = var.cluster_name
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.tjcloud.endpoint
  token = data.digitalocean_kubernetes_cluster.tjcloud.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.tjcloud.kube_config[0].cluster_ca_certificate
  )
}

module "system" {
  source = "./modules/system"
}

module "database" {
  source                 = "./modules/database"
  main_postgres_password = var.main_postgres_password
}

module "ingress" {
  source = "./modules/ingress"
}
