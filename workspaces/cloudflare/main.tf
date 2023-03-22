terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud-cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "tfe_outputs" "digitalocean" {
  organization = "tjpalanca"
  workspace    = "tjcloud-digitalocean"
}

provider "kubernetes" {
  host                   = data.tfe_outputs.digitalocean.values.cluster.host
  token                  = data.tfe_outputs.digitalocean.values.cluster.token
  cluster_ca_certificate = data.tfe_outputs.digitalocean.values.cluster.cluster_ca_certificate
}
