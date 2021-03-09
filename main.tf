#####
# Locals
#####

locals {
  annotations = {}
  labels = {
    "version"    = var.image_version
    "part-of"    = "monitoring"
    "managed-by" = "terraform"
    "name"       = "grafana"
    "component"  = "monitoring"
    "app"        = "grafana"

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

resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace

    labels = merge(
      local.labels,
      var.labels,
      var.deploymnet_labels
    )

    annotations = merge(
      {
        "prometheus.io/scrape" = "true",
        "prometheus.io/port"   = "3000"
      },
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
          { selector = "grafana-${random_string.selector.result}" },
          local.labels,
          var.labels,
          var.deployment_template_labels
        )

        annotations = merge(
          { "configuration/hash" = sha256(var.configuration) },
          local.annotations,
          var.annotations,
          var.deployment_annotations
        )
      }

      spec {
        container {
          name  = "grafana"
          image = format("%s:%s", var.image, var.image_version)
          port {
            name           = "http"
            container_port = 3000
          }
          service_account_name = kubernetes_service_account.this.metadata.0.name

          env_from {
            secret_ref {
              name = kubernetes_secret.this.metadata.0.name
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
              name       = "grafana-storage"
              mount_path = "/var/lib/grafana"
            }
          }

        }



        dynamic "volume" {
          for_each = var.enabled_localstorage ? [""] : []
          content {
            name = "grafana-storage"
            persistent_volume_claim {
              claim_name = "grafana_pvc"
            }
          }
        }


        automount_service_account_token = true

      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "grafan_pvc" {
  metadata {
    name = var.pvc_name
    annotations = merge(
      local.annotations,
      var.annotations,
      var.ingress_annotations
    )
    labels = merge(
      local.labels,
      var.labels,
      var.ingress_labels
    )
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.pvc_storage
      }
    }
    storage_class_name = var.pvc_storage_class_name

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
      {
        instance  = var.ingress_name
        component = "network"
      },
      local.labels,
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
    name      = var.kubernetes_service
    namespace = var.namespace

    annotations = merge(
      local.annotations,
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      local.labels,
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
      var.annotations,
      var.config_map_annotations
    )
    labels = merge(
      {
        instance = var.config_map_name
      },
      local.labels,
      var.labels,
      var.config_map_labels
    )
  }

  data = {
    "grafana.yml" = var.configuration
  }
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
      {
        "instance" = var.secret_name
      },
      local.labels,
      var.labels,
      var.secret_labels
    )
  }

  data = {
    "grafana_secret.yml" = var.grafana_secret
  }

  type = "Opaque"
}
