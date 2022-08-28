terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  node_count = 1
  main_nodes = data.linode_instances.main_nodes.instances
  main_node  = local.main_nodes.0
}

resource "linode_lke_cluster" "cluster" {
  label       = var.cluster_name
  k8s_version = "1.23"
  region      = var.linode_region
  pool {
    type  = "g6-standard-4"
    count = local.node_count
  }
}

data "linode_instances" "main_nodes" {
  filter {
    name = "id"
    values = [
      for node in linode_lke_cluster.cluster.pool.0.nodes :
      node.instance_id
    ]
  }
}

resource "null_resource" "reset_root_password" {

  for_each = data.linode_instances.main_nodes

  provisioner "local-exec" {
    command = <<EOF
      sleep 10 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${each.value.id}/shutdown && \
      sleep 30 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST -d "{\"password\": \"$PASSWORD\"}" \
        https://api.linode.com/v4/linode/instances/${each.value.id}/disks/${each.value.disk.0.id}/password && \
      sleep 5 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${each.value.id}/boot
    EOF
    environment = {
      TOKEN    = var.linode_token
      PASSWORD = var.root_password
    }
  }

}

resource "null_resource" "add_local_ssh_key" {

  for_each = data.linode_instances.main_nodes

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = each.value.ip_address
    }
    inline = [
      "echo ${var.local_ssh_key} > ~/.ssh/authorized_keys"
    ]
  }

}
