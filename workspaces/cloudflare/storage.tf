provider "aws" {
  access_key                  = var.r2_access_key
  secret_key                  = var.r2_secret_key
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  endpoints {
    s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  }
}

resource "aws_s3_bucket" "main" {
  bucket = var.user_name
}

resource "aws_s3_bucket" "public" {
  bucket = "${var.user_name}-public"
}
