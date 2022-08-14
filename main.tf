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
