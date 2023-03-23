locals {
  access_groups = [
    cloudflare_access_group.administrators
  ]
}

resource "cloudflare_access_group" "administrators" {
  account_id = var.cloudflare_account_id
  name       = "Administrators"
  include {
    email = var.admin_emails
  }
}
