#####
# Global
#####

variable "annotations" {
  description = "Map of annotations that will be merged with all other annotations on all kubernetes resources."
  default     = {}
}

variable "labels" {
  description = "Map of labels that will be merged with all other labels on all kubernetes resource."
  default     = {}
}

#####
# Namespace
#####

variable "namespace_name" {
  description = "Name of the namespace to create and deploy the grafana."
  default     = "grafana"
}

variable "namespace_annotations" {
  description = "Map of annotations to apply to the namespace."
  default     = {}
}

variable "namespace_labels" {
  description = "Map of labels to apply to the namespace."
  default     = {}
}

# variable "grafana_ingress_host" {}



variable "grafana_service_type" {}

variable "replica" {}

variable "grafana_node_port" {}

variable "grafana_persistent_volume_claim_storage" {}

variable "storage_class_name" {}

variable "deployment_name" {
  default = "grafana"
  type    = string
}

variable "image" {

}

variable "image_id" {

}

variable "cpu_limits" {

}

variable "mem_limits" {

}

variable "cpu_requests" {

}

variable "mem_requests" {

}

variable "enable_localstorage" {
  type = bool
}

variable "enabled_datasources" {
  type = bool
}

variable "kubernetes_service" {

}

variable "service_node_port" {

}
