terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  workspace = "/var/kaniko/${var.name}"
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

resource "null_resource" "build_context" {
  triggers = [var.build_context]
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = var.node.ip_address
  }
  provisioner "file" {
    source      = var.build_context
    destination = local.workspace
  }
}

resource "kubernetes_pod_v1" "kaniko_builder" {
  depends_on = [
    null_resource.build_context
  ]
  metadata {
    name      = "kaniko-builder-${var.name}"
    namespace = var.namespace
  }
  spec {
    node_name = var.node.label
    container {
      name  = "kaniko"
      image = "gcr.io/kaniko-project/executor:latest"
      args = [
        "--dockerfile=/workspace/${var.dockerfile_path}",
        "--context=dir://workspace",
        "--destination=${var.destination}"
      ]
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
