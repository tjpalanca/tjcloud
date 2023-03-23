terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
    }
  }
}

data "tfe_outputs" "cloudflare" {
  organization = "tjpalanca"
  workspace    = "tjcloud-cloudflare"
}

resource "cloudflare_access_application" "application" {
  name    = var.name
  zone_id = var.zone_id
  domain  = var.domain
}

resource "cloudflare_access_policy" "allowed_groups" {
  application_id = cloudflare_access_application.application.id
  zone_id        = var.zone_id
  decision       = "allow"
  precedence     = "1"
  name           = "${var.name}-allowed-groups"
  include {
    group = [
      for allowed_group in var.allowed_groups :
      data.tfe_outputs.cloudflare.values.access_groups[allowed_group]
    ]
  }
}
