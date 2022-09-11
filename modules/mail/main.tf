resource "kubernetes_namespace_v1" "mail" {
  metadata {
    name = "mail"
  }
}

module "mail_application" {
  source    = "../../elements/application"
  name      = "smtp"
  namespace = kubernetes_namespace_v1.mail.metadata[0].name
  ports     = [25]
  image     = "bytemark/smtp:latest"
  env_vars = {
    RELAY_HOST     = var.relay_host
    RELAY_PORT     = var.relay_port
    RELAY_USERNAME = var.relay_username
    RELAY_PASSWORD = var.relay_password
    RELAY_NETS     = "10.0.0.0/8;25.0.0.0/8;172.16.0.0/12;192.168.0.0/16"
  }
}
