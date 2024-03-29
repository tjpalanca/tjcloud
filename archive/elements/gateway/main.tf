terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 3.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

locals {
  host   = coalesce(var.host, var.service.name)
  zone   = var.zone_name
  domain = "${local.host}.${local.zone}"
}

resource "keycloak_openid_client" "client" {
  realm_id              = var.keycloak_realm_id
  client_id             = local.domain
  name                  = local.domain
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = concat(var.additional_redirect_uris, [
    "https://${local.domain}/oauth2/callback"
  ])
}

resource "keycloak_openid_client_default_scopes" "default_client_scopes" {
  realm_id  = var.keycloak_realm_id
  client_id = keycloak_openid_client.client.id

  default_scopes = concat(var.default_client_scopes, [
    "profile",
    "email",
    "roles",
    "web-origins"
  ])
}

resource "keycloak_openid_audience_protocol_mapper" "audience_mapper" {
  realm_id                 = var.keycloak_realm_id
  client_id                = keycloak_openid_client.client.id
  name                     = "audience"
  included_client_audience = keycloak_openid_client.client.name
  add_to_access_token      = true
  add_to_id_token          = false
}

resource "keycloak_openid_group_membership_protocol_mapper" "group_mapper" {
  realm_id            = var.keycloak_realm_id
  client_id           = keycloak_openid_client.client.id
  name                = "groups"
  claim_name          = "groups"
  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "random_password" "cookie_secret" {
  length           = 32
  override_special = "-_"
}

module "proxy_application" {
  source    = "../application"
  name      = "${var.service.name}-${var.service.port}-proxy"
  namespace = var.service.namespace
  ports     = [4180]
  replicas  = var.replicas
  image     = "quay.io/oauth2-proxy/oauth2-proxy:v7.3.0"
  env_vars = merge(
    {
      OAUTH2_PROXY_UPSTREAMS              = "http://${var.service.name}.${var.service.namespace}:${var.service.port}/"
      OAUTH2_PROXY_CLIENT_ID              = keycloak_openid_client.client.client_id
      OAUTH2_PROXY_CLIENT_SECRET          = keycloak_openid_client.client.client_secret
      OAUTH2_PROXY_ALLOWED_GROUPS         = join(",", [for g in var.keycloak_groups : "/${g}"])
      OAUTH2_PROXY_REVERSE_PROXY          = "true"
      OAUTH2_PROXY_REAL_CLIENT_IP_HEADER  = "X-Forwarded-For"
      OAUTH2_PROXY_SESSION_COOKIE_MINIMAL = "true"
      OAUTH2_PROXY_COOKIE_EXPIRE          = "168h0m0s"
      OAUTH2_PROXY_COOKIE_NAME            = "_${var.service.name}_oauth2_proxy"
      OAUTH2_PROXY_COOKIE_SECRET          = random_password.cookie_secret.result
      OAUTH2_PROXY_EMAIL_DOMAINS          = "*"
      OAUTH2_PROXY_HTTP_ADDRESS           = "0.0.0.0:4180"
      OAUTH2_PROXY_PROVIDER               = "keycloak-oidc"
      OAUTH2_PROXY_OIDC_ISSUER_URL        = "${var.keycloak_url}/realms/${var.keycloak_realm_id}"
      OAUTH2_PROXY_SKIP_PROVIDER_BUTTON   = "true"
      OAUTH2_PROXY_PREFER_EMAIL_TO_USER   = "true"
      OAUTH2_PROXY_PASS_USER_HEADERS      = "true"
    },
    var.additional_configuration
  )
}

module "proxy_ingress" {
  source                    = "../ingress"
  service                   = module.proxy_application.service
  host                      = local.host
  zone_id                   = var.zone_id
  zone_name                 = var.zone_name
  path                      = var.path
  ingress_class_name        = var.ingress_class_name
  annotations               = var.annotations
  authenticated_origin_pull = var.authenticated_origin_pull
  add_record                = var.add_record
  cname                     = var.cname
}
