variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable "linode_token" {
  type        = string
  description = "Linode API Token"
}

variable "linode_region" {
  type        = string
  default     = "ap-south"
  description = "Main Linode region"
}

variable "root_password" {
  type        = string
  description = "Root password for linode instances"
}

variable "local_ssh_key" {
  type        = string
  description = "SSH Key for the local machine for access"
}

variable "main_cloudflare_zone_id" {
  type        = string
  description = "Main Cloudflare Zone ID"
}

variable "main_cloudflare_zone_name" {
  type        = string
  description = "Main Cloudflare Zone Name"
}

variable "public_cloudflare_zone_id" {
  type        = string
  description = "Public Cloudflare Zone ID"
}

variable "public_cloudflare_zone_name" {
  type        = string
  description = "Public Cloudflare Zone Name"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_origin_ca_key" {
  type        = string
  description = "Private Key for Origin CA"
}

variable "cloudflare_origin_ca_private_key" {
  type        = string
  description = "Private Key for Origin CA"
}

variable "cloudflare_origin_ca_common_name" {
  type        = string
  description = "Origin CA Common Name"
}

variable "cloudflare_origin_ca_organization" {
  type        = string
  description = "Origin CA Organization"
}

variable "main_postgres_username" {
  type        = string
  description = "Username for the main postgres database"
}

variable "main_postgres_password" {
  type        = string
  description = "Password for the main postgres database"
}

variable "main_postgres_database" {
  type        = string
  description = "Main postgres database"
}

variable "pgadmin_default_username" {
  type        = string
  description = "PGAdmin initialized username"
}

variable "pgadmin_default_password" {
  type        = string
  description = "PGAdmin initialized password"
}

variable "keycloak_admin_username" {
  type        = string
  description = "Keycloak initialized username"
}

variable "keycloak_admin_password" {
  type        = string
  description = "Keycloak initialized password"
}

variable "keycloak_subdomain" {
  type        = string
  description = "Subdomain of keycloak"
}

variable "google_client_id" {
  type        = string
  description = "Google OAuth Client ID"
}

variable "google_client_secret" {
  type        = string
  description = "Google OAuth Client Secret"
}

variable "admin_emails" {
  type        = list(string)
  description = "List of emails that will be Administrator in the realm"
}

variable "ghcr_username" {
  type        = string
  description = "Username for GitHub Container Registry"
}

variable "ghcr_password" {
  type        = string
  description = "Password (token) for GitHub Container Registry"
}

variable "ghcr_email" {
  type        = string
  description = "Email for GitHub Container Registry"
}

variable "user_name" {
  type        = string
  description = "Username to be used"
}

variable "github_pat" {
  type        = string
  description = "Personal access token for dev environment"
}

variable "extensions_gallery_json" {
  type        = string
  description = "Extensions Gallery JSON for code-server"
}

variable "main_clickhouse_username" {
  type = string
}

variable "main_clickhouse_password" {
  type = string
}

variable "main_clickhouse_database" {
  type = string
}

variable "gmail_username" {
  type = string
}

variable "gmail_password" {
  type = string
}

variable "mailgun_username" {
  type = string
}

variable "mailgun_password" {
  type = string
}

variable "plausible_secret_key_base" {
  type = string
}

variable "mastodon_secret_key_base" {
  type = string
}

variable "mastodon_otp_secret" {
  type = string
}

variable "mastodon_vapid_private_key" {
  type = string
}

variable "mastodon_vapid_public_key" {
  type = string
}

variable "home_ip" {
  type        = string
  description = "Static IP for home network"
}

variable "freshrss_admin_username" {
  type = string
}

variable "freshrss_admin_password" {
  type = string
}

variable "mastodon_s3_access_key" {
  type = string
}

variable "mastodon_s3_secret_key" {
  type = string
}
