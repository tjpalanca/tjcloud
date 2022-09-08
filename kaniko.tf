module "kaniko" {
  source = "./modules/kaniko"
  depends_on = [
    module.cluster
  ]
}
