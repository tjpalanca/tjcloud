locals {
  main_node = data.linode_instances.production_nodes.0.instances.0
}

resource "linode_volume" "cluster_data" {
  label     = "${var.cluster_name}-data"
  region    = var.linode_region
  linode_id = local.main_node.id

  provisioner "local-exec" {
    command = <<EOT
      curl -H "Content-Type: application/json" 
      -H "Authorization: Bearer $TOKEN" 
      -X POST -d '{"password": "$PASSWORD"}' 
      https://api.linode.com/v4/linode/instances/${local.main_node.id}/disks/${local.main_node.disk.0.id}/password
    EOT
    environment = {
      TOKEN    = nonsensitive(var.linode_token)
      PASSWORD = nonsensitive(var.root_password)
    }
  }
}
