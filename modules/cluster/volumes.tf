locals {
  volume_name  = "${var.cluster_name}-data"
  volume_mount = "/mnt/${local.volume_name}"
}

resource "linode_volume" "main_node_volume" {
  label     = local.volume_name
  region    = var.linode_region
  linode_id = local.main_node.id
}

resource "null_resource" "mount_main_node_volume" {

  triggers = {
    main_node_instance_id  = local.main_node.id
    cluster_data_volume_id = linode_volume.main_node_volume.id
  }

  depends_on = [
    null_resource.reset_root_password
  ]

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = local.main_node.ip_address
    }
    inline = [
      "export DEVICE='${linode_volume.main_node_volume.filesystem_path}'",
      "export MOUNTPOINT=${local.volume_mount}",
      "export FSTYPE='ext4'",
      "blkid --match-token TYPE=$FSTYPE $DEVICE || mkfs.ext4 $DEVICE",
      "mkdir -p $MOUNTPOINT",
      "mount $DEVICE $MOUNTPOINT",
      "echo \"$DEVICE $MOUNTPOINT ext4 defaults,noatime,nofail 0 2\" >> /etc/fstab"
    ]
  }

}
