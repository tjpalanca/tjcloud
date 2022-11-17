variable "service" {
  type = object({
    name      = string
    port      = number
    namespace = string
  })
  description = "Details about the upstream service"
}

variable "keycloak_realm_id" {
  type        = string
  description = "Keycloak Realm ID"
}

variable "keycloak_url" {
  type        = string
  description = "Keycloak URL"
}

variable "keycloak_groups" {
  type        = list(string)
  default     = []
  description = "Groups allowed to access the proxied service"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone to expose"
}

variable "zone_name" {
  type        = string
  description = "Cloudflare zone name to expose"
}

variable "host" {
  type        = string
  default     = null
  description = "Host name to respond to"
}

variable "path" {
  type        = string
  default     = "/"
  description = "Subpath to serve the ingress at"
}

variable "ingress_class_name" {
  type        = string
  default     = "nginx"
  description = "Class of the ingress to be provisioned"
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to the ingress"
}

variable "default_client_scopes" {
  type        = list(string)
  default     = []
  description = "additional default client scopes"
}

variable "authenticated_origin_pull" {
  type        = bool
  default     = true
  description = "Whether or not to verify the client certificate"
}

variable "additional_redirect_uris" {
  type        = list(string)
  default     = []
  description = "Additional redirect URIs"
}

variable "additional_configuration" {
  type        = map(string)
  default     = {}
  description = "Additional env vars"
}

variable "add_record" {
  type        = bool
  default     = true
  description = "Whether or not to add a cloudflare record"
}

variable "cname" {
  type        = string
  default     = null
  description = "CNAME value for cloudflare record, in case it is different from zone"
}
