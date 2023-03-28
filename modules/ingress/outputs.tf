output "zone_id" {
  value = cloudflare_record.record.zone_id
}

output "domain" {
  value = local.domain
}

output "subdomain" {
  value = var.subdomain
}
