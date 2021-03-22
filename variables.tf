#####
# Global
#####

variable "annotations" {
  description = "Map of annotations that will be merged with all other annotations on all kubernetes resources."
  default     = {}
  type        = map(string)
}

variable "labels" {
  description = "Map of labels that will be merged with all other labels on all kubernetes resource."
  default     = {}
  type        = map(string)
}

variable "namespace" {
  description = "Namespace in which the module will be deployed."
  default     = "grafana"
  type        = string
}

variable "deployment_template_labels" {
  description = "Map of annotations to apply to the namespace."
  default     = {}
  type        = map(string)
}

variable "deployment_annotations" {
  description = "Additionnal labels that will be merged on the deployment."
  default     = {}
  type        = map(string)
}
#####
# Application
#####



variable "deployment_name" {
  description = "Name of the deployment that will be create."
  default     = "grafana"
  type        = string
}

variable "replicas" {
  description = "Number of replicas to deploy."
  default     = 1
  type        = number
}

variable "deployment_template_annotations" {
  description = "Additionnal annotations that will be merged on the deployment."
  default     = {}
  type        = map(string)
}

variable "image" {
  description = "Image to use."
  default     = "grafana/grafana"
  type        = string
}

variable "image_version" {
  description = "Version of the image to use."
  default     = "latest"
  type        = string
}

variable "resources_requests_cpu" {
  description = "Amount of cpu time that the application requests."
  default     = "100m"
  type        = string
}

variable "resources_requests_memory" {
  description = "Amount of memory that the application requests."
  default     = "256Mi"
  type        = string
}

variable "resources_limits_cpu" {
  description = "Amount of cpu time that the application limits."
  default     = "500m"
  type        = string
}

variable "resources_limits_memory" {
  description = "Amount of memory that the application limits."
  default     = "512Mi"
  type        = string
}

#####
# Service
#####

variable "service_name" {
  description = "Name of the service."
  default     = "grafana"
  type        = string
}

variable "service_annotations" {
  description = "Map of annotations that will be applied on the service."
  default     = {}
  type        = map(string)
}

variable "service_labels" {
  description = "Map of labels that will be applied on the service."
  default     = {}
  type        = map(string)
}

variable "enabled_localstorage" {
  description = "should local storage be enabled for grafana"
  type        = bool
  default     = true
}

#####
# Ingress
#####

variable "ingress_enabled" {
  description = "Whether or not to enable the ingress."
  default     = true
  type        = bool
}

variable "ingress_name" {
  description = "Name of the ingress."
  default     = "grafana"
  type        = string
}

variable "ingress_annotations" {
  description = "Map of annotations that will be applied on the ingress."
  default     = {}
  type        = map(string)
}

variable "ingress_labels" {
  description = "Map of labels that will be applied on the ingress."
  default     = {}
  type        = map(string)
}

variable "pvc_annotations" {
  description = "Map of annotations that will be applied on the ingress."
  default     = {}
  type        = map(string)
}

variable "pvc_labels" {
  description = "Map of labels that will be applied on the ingress."
  default     = {}
  type        = map(string)
}

variable "ingress_host" {
  description = "Host on which the ingress wil be available (ex: grafana.example.com)."
  default     = "grafana.example.com"
  type        = string
}

variable "ingress_tls_enabled" {
  description = "Whether or not TLS should be enabled on the ingress."
  default     = true
  type        = bool
}

variable "ingress_tls_secret_name" {
  description = "Name of the secret to use to put TLS on the ingress."
  default     = "grafana"
  type        = string
}

variable "additionnal_ingress_paths" {
  description = <<-DOCUMENTATION
A list of map of additionnal ingress path to add. Map must support the following structure:
  * service_name (optional, string): The name of the kubernates service. (e.g. ssl-redirect)
  * service_port (optional, string): The service port number (e.g. use-annotation).
  * path (optional, string): The path to the service

For example, see folder examples/without-pvc.
DOCUMENTATION
  type        = list(any)
  default     = []
}

variable "service_type" {
  description = "type of service"
  type        = string
  default     = "NodePort"
}

variable "service_account_name" {
  description = "name of the service account"
  default     = "grafana"
  type        = string
}

variable "service_account_annotations" {
  description = "Map of annotations that is merged on the service account."
  default     = {}
  type        = map(string)
}

variable "service_account_labels" {
  description = "Map of labels that is merged on the service account."
  default     = {}
  type        = map(string)
}

variable "config_map_name" {
  description = "Name of the config map that will be created."
  default     = "grafana"
  type        = string
}

variable "config_map_annotations" {
  description = "Additionnal annotations that will be merged for the config map."
  default     = {}
  type        = map(string)
}

variable "config_map_labels" {
  description = "Additionnal labels that will be merged for the config map."
  default     = {}
  type        = map(string)
}

variable "configuration" {
  description = "Configuration to use for grafana, all the key pairs will be mounted as env variables not as a file "
  type        = map(string)
  default     = {}
}

variable "secret_name" {
  description = "Name of the secret that will be created."
  default     = "grafana"
  type        = string
}

variable "secret_annotations" {
  description = "Additionnal annotations that will be merged for the secret."
  default     = {}
  type        = map(string)
}

variable "secret_labels" {
  description = "Additionnal labels that will be merged for the secret."
  default     = {}
  type        = map(string)
}

variable "deploymnet_labels" {
  description = "deploymnet labels  that will be merged for the deployment."
  default     = {}
  type        = map(string)
}

variable "secret_configuration" {
  description = <<-DOCUMENTATION

  # should contain grafana secret env variables, see the example below
  #   For example, {
  #   { "GF_SECURITY_ADMIN_PASSWORD" = "xxxxx" }
  # }
  #
   DOCUMENTATION
  type        = map(string)
  default     = {}

}

variable "pvc_name" {
  description = "Name of the PVC for gradfana"
  type        = string
  default     = "grafana"
}

variable "pvc_storage" {
  description = "storage required for pvc "
  type        = string
  default     = "10Gi"
}

variable "pvc_storage_class_name" {
  description = "Name of the storage class that will be applied to persistent volume claim."
  type        = string
  default     = null
}

variable "pvc_volume_name" {
  description = "Name of the volume bound to the persistent volume claim."
  type        = string
  default     = ""
}

variable "pvc_wait_until_bound" {
  description = "Whether to wait for the claim to reach Bound state (to find volume in which to claim the space)"
  default     = false
  type        = bool
}

variable "pvc_access_modes" {
  description = "A set of the desired access modes the volume should have."
  default     = ["ReadWriteOnce"]
  type        = list(string)
}
