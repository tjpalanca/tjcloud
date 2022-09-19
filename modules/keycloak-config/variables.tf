variable "settings" {
  type = object({
    realm_name         = string
    realm_display_name = string
    admin_emails       = list(string)
  })
}

variable "identity_providers" {
  type = object({
    google = object({
      client_id     = string
      client_secret = string
    })
  })
}
