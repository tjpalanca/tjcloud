module "plausible" {
  source = "./modules/plausible"
  providers = {
    postgresql = postgresql.main
  }
  postgres             = module.database.main_postgres_credentials
  clickhouse           = module.database.main_clickhouse_credentials
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
  smtp_host            = "${module.mail.service.name}.${module.mail.service.namespace}"
}
