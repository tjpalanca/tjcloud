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
  source = "./modules/cluster"
}

resource "digitalocean_project" "tjcloud" {
  name        = "TJCloud"
  description = "TJ Palanca's Personal Cloud"
  purpose     = "Machine learning / AI / Data processing"
  environment = "Production"
  resources = [
    module.cluster.cluster.urn
  ]
}

module "database" {
  source                 = "./modules/database"
  main_postgres_password = var.main_postgres_password
}

module "ingress" {
  source = "./modules/ingress"
}
