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
  }
}

locals {
  node_count = 1
  main_node  = data.linode_instances.production_nodes.0.instances.0
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

data "linode_instances" "production_nodes" {
  count = local.node_count
  filter {
    name = "id"
    values = [
      linode_lke_cluster.cluster.pool.0.nodes[count.index].instance_id
    ]
  }
}

resource "null_resource" "reset_root_password" {

  triggers = {
    main_node_instance_id = local.main_node.id
  }

  provisioner "local-exec" {
    command = <<EOF
      sleep 10 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${local.main_node.id}/shutdown && \
      sleep 30 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST -d "{\"password\": \"$PASSWORD\"}" \
        https://api.linode.com/v4/linode/instances/${local.main_node.id}/disks/${local.main_node.disk.0.id}/password && \
      sleep 5 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${local.main_node.id}/boot
    EOF
    environment = {
      TOKEN    = var.linode_token
      PASSWORD = var.root_password
    }
  }

}

resource "null_resource" "add_local_ssh_key" {

  triggers = {
    main_node_instance_id = local.main_node.id
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = local.main_node.ip_address
    }
    inline = [
      "echo ${var.local_ssh_key} > ~/.ssh/authorized_keys"
    ]
  }

}

resource "null_resource" "inspect_environment" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = local.main_node.ip_address
    }
    inline = [
      "echo $(which python)"
    ]
  }
}
