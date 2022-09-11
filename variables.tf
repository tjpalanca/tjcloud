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

variable "main_cloudflare_zone" {
  type        = string
  description = "Zone at which the cluster ingress will be exposed"
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

variable "keycloak_realm_display_name" {
  type        = string
  description = "Keycloak display name for login page"
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
