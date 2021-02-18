
#####
# Locals
#####

locals {
  annotations = {

  }
  labels = {
    "version"    = var.image_version
    "part-of"    = "monitoring"
    "managed-by" = "terraform"
    "name"       = "grafana"
    "component"  = "monitoring"
    "app"        = "grafana"

  }
  volume_mount_localstorage = var.enabled_localstorage ? [{ name : "grafana-storage", mount_path : "/var/lib/grafana" }] : []
  volume_mount_datasources  = var.enabled_datasources ? [{ name : "grafana-datasources", mount_path : "/etc/grafana/provisioning/datasources" }] : []
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
      { "configmap.reloader.stakater.com/reload" = "grafana-datasources",
        "prometheus.io/scrape"                   = "true",
      "prometheus.io/port" = "3000" },

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
            for_each = local.volume_mount_localstorage
            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
            }
          }

          dynamic "volume_mount" {
            for_each = local.volume_mount_datasources
            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
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


resource "kubernetes_service" "service" {
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
      target_port = http
      node_port   = var.service_node_port
    }

    type = var.service_type
  }
}
