variable "admin_emails" {
  type = list(string)
}

variable "google" {
  type = object({
    client_id     = string
    client_secret = string
  })
}
