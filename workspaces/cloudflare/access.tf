resource "cloudflare_access_identity_provider" "github" {
  account_id = var.cloudflare_account_id
  name       = "GitHub"
  type       = "github"
  config {
    client_id     = var.github_client_id
    client_secret = var.github_client_secret
  }
}

resource "cloudflare_access_identity_provider" "google" {
  account_id = var.cloudflare_account_id
  name       = "Google"
  type       = "google"
  config {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret
  }
}
