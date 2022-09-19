terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
  }
}

resource "linode_object_storage_bucket" "user" {
  cluster = "ap-south-1"
  label   = var.user_name
}
