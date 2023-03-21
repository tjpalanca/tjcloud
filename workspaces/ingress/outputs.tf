output "authenticated_origin_pulls_secret" {
  value = "${kubernetes_secret_v1.authenticated_origin_pull_ca.metadata[0].namespace}/${kubernetes_secret_v1.authenticated_origin_pull_ca.metadata[0].name}"
}
