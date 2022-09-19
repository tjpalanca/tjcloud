module "mail" {
  source         = "./modules/mail"
  relay_host     = "smtp.gmail.com"
  relay_username = var.gmail_username
  relay_password = var.gmail_password
}
