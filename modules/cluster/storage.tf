locals {
  main_node = linode_lke_cluster.cluster.pool.0.nodes.0
}

resource "linode_volume" "cluster_data" {
  label     = "${var.cluster_name}-data"
  region    = var.linode_region
  linode_id = local.main_node.instance_id

  provisioner "local-exec" {
    command = <<EOF
      curl -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -X POST -d '{"password": "$PASSWORD"}' \
      https://api.linode.com/v4/linode/instances/$INSTANCE_ID/disks/$DISK_ID/password"
    EOF
    environment = {
      TOKEN       = var.linode_token
      PASSWORD    = var.root_password
      INSTANCE_ID = local.main_node.id
      DISK_ID     = local.main_node.disk.0.id
    }
  }
}
