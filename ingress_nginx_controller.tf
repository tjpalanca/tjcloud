module "ingress_nginx_controller" {
  source = "./modules/ingress_nginx_controller"
  cloudflare_origin_ca = {
    common_name  = var.cloudflare_origin_ca_common_name
    organization = var.cloudflare_origin_ca_organization
    private_key  = var.cloudflare_origin_ca_private_key
  }
  cloudflare_zone_id = var.main_cloudflare_zone_id
  depends_on = [
    module.cluster
  ]
}
