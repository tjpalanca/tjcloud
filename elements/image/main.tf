terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  workspace = "/var/kaniko/build/${var.name}/"
  cache_dir = "/var/kaniko/cache/"
  versioned = "${var.image_address}:${var.image_version}"
  latest    = "${var.image_address}:latest"
}

resource "kubernetes_secret_v1" "registry_secret" {
  metadata {
    name      = "kaniko-secret-${var.name}"
    namespace = var.namespace
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry.server}" = {
          "username" = var.registry.username
          "password" = var.registry.password
          "email"    = var.registry.email
          "auth"     = base64encode("${var.registry.username}:${var.registry.password}")
        }
      }
    })
  }
}

data "archive_file" "build_context" {
  type        = "zip"
  source_dir  = var.build_context
  output_path = "${var.name}.zip"
}

resource "null_resource" "build_context" {
  triggers = {
    build_context_path = data.archive_file.build_context.output_path
    build_context_hash = data.archive_file.build_context.output_sha
  }
  connection {
    type     = "ssh"
    user     = "root"
    password = var.node_password
    host     = var.node.ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.workspace}",
      "mkdir -p ${local.cache_dir}"
    ]
  }
  provisioner "file" {
    source      = var.build_context
    destination = local.workspace
  }
  provisioner "remote-exec" {
    inline = concat(["cd ${local.workspace}"], var.post_copy_commands)
  }
}

resource "kubernetes_job_v1" "kaniko_warmer" {
  count = length(var.warm_images) > 0 ? 1 : 0
  metadata {
    name      = "kaniko-warmer-${var.name}"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {}
      spec {
        node_name = var.node.label
        container {
          name  = "kaniko-warmer"
          image = "gcr.io/kaniko-project/warmer:latest"
          args = concat(
            ["--cache-dir=/cache"],
            [for img in var.warm_images : "--image=${img}"]
          )
          volume_mount {
            name       = "kaniko-secret"
            mount_path = "/kaniko/.docker"
          }
          volume_mount {
            name       = "cache"
            mount_path = "/cache"
          }
        }
        restart_policy = "Never"
        volume {
          name = "kaniko-secret"
          secret {
            secret_name = kubernetes_secret_v1.registry_secret.metadata.0.name
            items {
              key  = ".dockerconfigjson"
              path = "config.json"
            }
          }
        }
        volume {
          name = "cache"
          host_path {
            path = local.cache_dir
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}

resource "kubernetes_job_v1" "kaniko_builder" {
  lifecycle {
    replace_triggered_by = [
      null_resource.build_context
    ]
  }
  metadata {
    name      = "kaniko-builder-${var.name}"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {}
      spec {
        node_name = var.node.label
        container {
          name  = "kaniko-builder"
          image = "gcr.io/kaniko-project/executor:latest"
          args = concat(
            [
              "--dockerfile=/workspace/${var.dockerfile_path}",
              "--context=dir:///workspace",
              "--destination=${local.versioned}",
              "--destination=${local.latest}",
              "--cache=true"
            ],
            [for k, v in var.build_args : "--build-arg=${k}=${v}"]
          )
          volume_mount {
            name       = "kaniko-secret"
            mount_path = "/kaniko/.docker"
          }
          volume_mount {
            name       = "workspace"
            mount_path = "/workspace"
          }
        }
        restart_policy = "Never"
        volume {
          name = "kaniko-secret"
          secret {
            secret_name = kubernetes_secret_v1.registry_secret.metadata.0.name
            items {
              key  = ".dockerconfigjson"
              path = "config.json"
            }
          }
        }
        volume {
          name = "workspace"
          host_path {
            path = local.workspace
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}
