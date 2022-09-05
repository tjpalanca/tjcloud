

variable "service" {
  type = object({
    name      = string
    port      = number
    namespace = string
  })
  description = "Details about the upstream service"
}

variable "keycloak_realm" {
  type = object({
    id   = string
    name = string
  })
  description = "Keycloak Realm"
}

variable "keycloak_url" {
  type        = string
  description = "Keycloak URL"
}

variable "keycloak_groups" {
  type        = list(string)
  default     = [""]
  description = "Groups allowed to access the proxied service"
}

variable "zone" {
  type        = string
  description = "Cloudflare zone to expose"
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