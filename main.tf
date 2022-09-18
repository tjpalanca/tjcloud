terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.29.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.35.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.10.0"
    }
  }
  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud"
    }
  }
}

locals {
  ghcr_registry = {
    server   = "ghcr.io"
    username = var.ghcr_username
    password = var.ghcr_password
    email    = var.ghcr_email
  }
  cloudflare = {
    main_zone_id   = "cef2ca3494d70c14773cc770cc64520a"
    public_zone_id = "b7fa96d04fa21095d0e2d21a9e26d7e8"
  }
}
