terraform {

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
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
  source = "./modules/cluster"
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
