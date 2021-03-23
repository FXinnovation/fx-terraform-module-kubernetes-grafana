#####
# Locals
#####

locals {
  annotations = {}
  labels = {
    "version"     = var.image_version
    "part-of"     = "monitoring"
    "managed-by"  = "terraform"
    "name"        = "grafana"
    "application" = "grafana"

  }
}

#####
# Randoms
#####

resource "random_string" "selector" {
  special = false
  upper   = false
  number  = false
  length  = 8
}

#####
# Deployment
#####

resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
    labels = merge(
      local.labels,
      {
        instance  = var.deployment_name
        component = "application"
      },
      var.labels,
      var.deploymnet_labels
    )
    annotations = merge(
      local.annotations,
      var.annotations,
      var.deployment_annotations
    )
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        selector = "grafana-${random_string.selector.result}"
      }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = "33%"
      }
    }

    template {
      metadata {
        labels = merge(
          local.labels,
          {
            selector  = "grafana-${random_string.selector.result}",
            instance  = var.deployment_name,
            component = "application"
          },
          var.labels,
          var.deployment_template_labels
        )
        annotations = merge(
          local.annotations,
          { "configuration/hash" = sha256(join(", ", values(var.configuration))) },
          var.annotations,
          var.deployment_template_annotations
        )
      }

      spec {
        service_account_name            = kubernetes_service_account.this.metadata.0.name
        automount_service_account_token = true
        container {
          name  = "grafana"
          image = format("%s:%s", var.image, var.image_version)
          port {
            name           = "http"
            container_port = 3000
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.this.metadata.0.name
            }
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.this.metadata.0.name
            }
          }
          resources {
            limits {
              cpu    = var.resources_limits_cpu
              memory = var.resources_limits_memory
            }
            requests {
              cpu    = var.resources_requests_cpu
              memory = var.resources_requests_memory
            }
          }

          dynamic "volume_mount" {
            for_each = var.enabled_localstorage ? [""] : []
            content {
              name       = "grafana-volume"
              mount_path = "/var/lib/grafana"
            }
          }
        }

        dynamic "volume" {
          for_each = var.enabled_localstorage ? [""] : []
          content {
            name = "grafana-volume"
            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
            }
          }
        }

      }
    }
  }
}

#####
# PVC
#####

resource "kubernetes_persistent_volume_claim" "this" {
  wait_until_bound = var.pvc_wait_until_bound
  metadata {
    name      = var.pvc_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.pvc_annotations
    )
    labels = merge(
      local.labels,
      {
        instance  = var.pvc_name
        component = "storage"
      },
      var.labels,
      var.pvc_labels
    )
  }

  spec {
    access_modes       = var.pvc_access_modes
    storage_class_name = var.pvc_storage_class_name
    resources {
      requests = {
        storage = var.pvc_storage
      }
    }
    volume_name = var.pvc_volume_name
  }
}

#####
# Ingress
#####

resource "kubernetes_ingress" "this" {
  count = var.ingress_enabled ? 1 : 0
  metadata {
    name      = var.ingress_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.ingress_annotations
    )
    labels = merge(
      local.labels,
      {
        instance  = var.ingress_name
        component = "network"
      },
      var.labels,
      var.ingress_labels
    )
  }
  spec {
    backend {
      service_name = kubernetes_service.this.metadata.0.name
      service_port = "http"
    }
    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service_name = kubernetes_service.this.metadata.0.name
            service_port = "http"
          }
          path = "/"
        }

        dynamic "path" {
          for_each = var.additionnal_ingress_paths
          content {
            backend {
              service_name = lookup(path.value, "service_name", kubernetes_service.this.metadata.0.name)
              service_port = lookup(path.value, "service_port", "http")
            }
            path = lookup(path.value, "path", null)
          }
        }
      }
    }
    dynamic "tls" {
      for_each = var.ingress_tls_enabled ? [1] : []
      content {
        secret_name = var.ingress_tls_secret_name
        hosts       = [var.ingress_host]
      }
    }
  }
}

#####
# Service
#####

resource "kubernetes_service" "this" {
  metadata {
    name      = var.service_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      local.labels,
      {
        instance  = var.service_name
        component = "network"
      },
      var.labels,
      var.service_labels
    )
  }
  spec {
    selector = { selector = "grafana-${random_string.selector.result}" }
    port {
      name        = "http"
      port        = 80
      target_port = "http"
    }
    type = var.service_type
  }
}

#####
# Service Account
#####

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.service_account_annotations
    )
    labels = merge(
      local.labels,
      {
        instance  = var.service_account_name
        component = "rbac"
      },
      var.labels,
      var.service_account_labels
    )
  }
}

#####
# ConfigMap
#####

resource "kubernetes_config_map" "this" {
  metadata {
    name      = var.config_map_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.config_map_annotations
    )
    labels = merge(
      local.labels,
      {
        instance  = var.config_map_name
        component = "configuration"
      },
      var.labels,
      var.config_map_labels
    )
  }

  data = var.configuration
}

#####
# Secret
#####

resource "kubernetes_secret" "this" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace
    annotations = merge(
      var.annotations,
      var.secret_annotations
    )
    labels = merge(
      local.labels,
      {
        "instance" = var.secret_name
        component  = "configuration"
      },
      var.labels,
      var.secret_labels
    )
  }
  data = var.secret_configuration
  type = "Opaque"
}
