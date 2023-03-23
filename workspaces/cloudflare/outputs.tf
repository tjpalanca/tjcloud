output "authenticated_origin_pulls_secret" {
  value = "${kubernetes_secret_v1.authenticated_origin_pull_ca.metadata[0].namespace}/${kubernetes_secret_v1.authenticated_origin_pull_ca.metadata[0].name}"
}

output "ingress_class_name" {
  value = kubernetes_ingress_class_v1.nginx.metadata[0].name
}

output "access_groups" {
  value = zipmap(
    [for ag in local.access_groups : ag.name],
    [for ag in local.access_groups : ag.id]
  )
}
