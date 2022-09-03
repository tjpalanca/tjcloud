output "image" {
  value = {
    image     = var.image_address
    version   = var.image_version
    versioned = local.versioned
    latest    = local.latest
  }
}
