module "plausible" {
  source = "./modules/plausible"
  providers = {
    postgresql = postgresql.main
  }
  postgres                = module.database.main_postgres_credentials
  clickhouse              = module.database.main_clickhouse_credentials
  google_client_id        = var.google_client_id
  google_client_secret    = var.google_client_secret
  smtp_host               = "${module.mail.service.name}.${module.mail.service.namespace}"
  subdomain               = "analytics"
  cloudflare_zone_id      = var.public_cloudflare_zone_id
  main_cloudflare_zone_id = var.main_cloudflare_zone_id
  secret_key_base         = var.plausible_secret_key_base
  admin_user = {
    email    = var.plausible_admin_user_email
    name     = var.plausible_admin_user_name
    password = var.plausible_admin_user_password
  }
}
