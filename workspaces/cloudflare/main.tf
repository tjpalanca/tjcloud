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
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.26.0"
    }
  }
  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud-cloudflare"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "cloudflare" {
  alias                = "cloudflare_origin_ca_key"
  api_user_service_key = var.cloudflare_origin_ca_key
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

data "cloudflare_ip_ranges" "cloudflare" {}
