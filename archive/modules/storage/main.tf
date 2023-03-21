terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.21.0"
    }
  }
}

data "linode_object_storage_cluster" "primary" {
  id = "ap-south-1"
}

resource "linode_object_storage_bucket" "user" {
  cluster = data.linode_object_storage_cluster.primary.id
  label   = var.user_name
}

resource "linode_object_storage_bucket" "media" {
  cluster      = data.linode_object_storage_cluster.primary.id
  label        = "media.${var.public_cloudflare_zone_name}"
  acl          = "public-read"
  cors_enabled = true
}

resource "cloudflare_record" "media" {
  zone_id = var.public_cloudflare_zone_id
  name    = "media"
  type    = "CNAME"
  value   = linode_object_storage_bucket.media.hostname
  proxied = true
}
