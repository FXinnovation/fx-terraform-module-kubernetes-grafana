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
    namespace = var.namespace_name

    labels = merge(
      local.labels,
      var.labels,
      var.namespace_labels
    )

    annotations = merge(
      {
        "configmap.reloader.stakater.com/reload" = "grafana-datasources",
        "prometheus.io/scrape"                   = "true",
        "prometheus.io/port"                     = "3000"
      },
      local.annotations,
      var.annotations,
      var.namespace_annotations
    )

  }

  spec {
    replicas = var.replica
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
          var.namespace_labels
        )
      }

      spec {
        container {
          name  = "grafana"
          image = format("%s:%s", var.image, var.image_id)
          port {
            name           = "http"
            container_port = 3000
          }

          resources {
            limits {
              cpu    = var.cpu_limits
              memory = var.mem_limits
            }
            requests {
              cpu    = var.cpu_requests
              memory = var.mem_requests
            }
          }

          dynamic "volume_mount" {
            for_each = var.enabled_localstorage ? [""] : []
            content {
              name       = "grafana-storage"
              mount_path = "/var/lib/grafana"
            }
          }

          dynamic "volume_mount" {
            for_each = var.enabled_datasources ? [""] : []
            content {
              name       = "grafana-datasources"
              mount_path = "/etc/grafana/provisioning/datasources"
            }
          }
        }

        dynamic "volume" {
          for_each = var.enabled_localstorage ? [""] : []
          content {
            name = "grafana-storage"
            persistent_volume_claim {
              claim_name = "grafana-pvc"
            }
          }
        }

        dynamic "volume" {
          for_each = var.enabled_datasources ? [""] : []
          content {
            name = "grafana-datasources"
            config_map {
              default_mode = "0666"
              name         = "grafana-datasources"
            }
          }
        }

        automount_service_account_token = true
        # node_selector = {
        #   type = "master"
        # }
        # security_context {
        #   fs_group = "472"
        # }
      }
    }
  }
}

#####
# Ingress
#####

resource "kubernetes_ingress" "this" {
  count = var.enabled && var.ingress_enabled ? 1 : 0

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
      service_name = element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)
      service_port = "http"
    }

    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service_name = element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)
            service_port = "http"
          }
          path = "/"
        }

        dynamic "path" {
          for_each = var.additionnal_ingress_paths

          content {
            backend {
              service_name = lookup(path.value, "service_name", element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0))
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

resource "kubernetes_service" "this" {

  count = var.enabled ? 1 : 0

  metadata {
    name      = var.kubernetes_service
    namespace = var.namespace_name

    annotations = merge(
      local.annotations,
      var.annotations,
      var.namespace_annotations
    )
  }

  spec {
    selector = {
      app = "grafana"
    }
    port {
      name        = "http"
      port        = 80
      target_port = "http"
      node_port   = var.service_node_port
    }

    type = var.service_type
  }
}

resource "kubernetes_service_account" "this" {
  count = var.enabled ? 1 : 0

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
      var.service_account_annotations
    )
  }
}

#####
# ConfigMap
#####

resource "kubernetes_config_map" "this" {
  count = var.enabled ? 1 : 0

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
  count = var.enabled ? 1 : 0

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

    user_name = var.user_name
    password  = var.password
  }

  type = "Opaque"
}
