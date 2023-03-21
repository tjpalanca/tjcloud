output "media_bucket" {
  value = merge(linode_object_storage_bucket.media, {
    domain = data.linode_object_storage_cluster.primary.domain
  })
}
