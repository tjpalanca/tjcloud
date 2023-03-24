provider "aws" {
  alias                       = "cloudflare"
  region                      = "us-east-1"
  access_key                  = var.cloudflare_r2_access_key
  secret_key                  = var.cloudflare_r2_secret_key
  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = var.cloudflare_r2_endpoint
  }
}
