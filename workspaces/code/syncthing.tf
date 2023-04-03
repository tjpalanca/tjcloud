module "syncthing_deployment" {
  source    = "../../modules/deployment"
  name      = "syncthing"
  image     = "syncthing/syncthing:latest"
  namespace = module.code_namespace.name
  replicas  = 0
  env_vars = {
    PUID = 1000
    PGID = 1000
  }
  ports     = [8384]
  tcp_ports = [22000]
  udp_ports = [22000, 21027]
  mounts = [
    {
      mount_path  = "/var/syncthing/home/${var.user_name}"
      volume_path = "files/home/${var.user_name}/"
      claim_name  = module.code_volume_claim.name
      owner_uid   = 1000
    }
  ]
}

module "syncthing_service" {
  source     = "../../modules/service"
  name       = "syncthing"
  namespace  = module.syncthing_deployment.namespace
  deployment = module.syncthing_deployment.name
  ports      = module.syncthing_deployment.ports
}

module "syncthing_ingress" {
  source            = "../../modules/ingress"
  subdomain         = "syncthing"
  zone_id           = var.dev_zone_id
  zone_name         = var.dev_zone_name
  cname_zone_name   = var.dev_zone_name
  service_name      = module.syncthing_service.name
  service_port      = module.syncthing_service.ports[0]
  service_namespace = module.syncthing_service.namespace
}

module "syncthing_gateway" {
  source         = "../../modules/gateway"
  name           = "Syncthing"
  logo_url       = "https://storage.tjpalanca.com/images/hotlink-ok/logos/syncthing.png"
  zone_id        = module.syncthing_ingress.zone_id
  domain         = module.syncthing_ingress.domain
  allowed_groups = ["Administrators"]
}
