locals {
  volume_name = "${var.cluster_name}-data"
}

resource "linode_volume" "cluster_data" {
  label     = local.volume_name
  region    = var.linode_region
  linode_id = local.main_node.id
}

resource "null_resource" "mount_volume" {

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
      "export DEVICE='${self.filesystem_path}'",
      "export FSTYPE='ext4'",
      <<EOF
      if ! lsblk -o NAME,FSTYPE | grep $DEVICE | grep $FSTYPE; then
          mkfs.ext4 $DEVICE
      fi
      EOF
      ,
      "mkdir -p /mnt/${local.volume_name}",
      "mount ${self.filesystem_path} /mnt/${local.volume_name}"
    ]
  }

}
