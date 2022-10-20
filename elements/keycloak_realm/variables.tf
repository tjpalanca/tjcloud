variable "name" {
  type = string
}

variable "name_html" {
  type = string
}

variable "login_theme" {
  type = string
}

variable "google" {
  type = object({
    client_id     = string
    client_secret = string
  })
}
