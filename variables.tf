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

variable "namespace" {
  description = "Namespace in which the module will be deployed."
  default     = "default"
}

variable "deployment_template_labels" {
  description = "Map of annotations to apply to the namespace."
  default     = {}
}

variable "deployment_labels" {
  description = "Additionnal labels that will be merged on the deployment."
  default     = {}
}
#####
# Application
#####



variable "deployment_name" {
  description = "Name of the deployment that will be create."
  default     = "grafana"
}

variable "replicas" {
  description = "Number of replicas to deploy."
  default     = 1
}

variable "deployment_annotations" {
  description = "Additionnal annotations that will be merged on the deployment."
  default     = {}
}

variable "image" {
  description = "Image to use."
  default     = "fxinnovation/grafana"
}

variable "image_version" {
  description = "Version of the image to use."
  default     = ""
}

variable "resources_requests_cpu" {
  description = "Amount of cpu time that the application requests."
  default     = "1"
}

variable "resources_requests_memory" {
  description = "Amount of memory that the application requests."
  default     = "2048Mi"
}

variable "resources_limits_cpu" {
  description = "Amount of cpu time that the application limits."
  default     = "2"
}

variable "resources_limits_memory" {
  description = "Amount of memory that the application limits."
  default     = "4096Mi"
}

#####
# Service
#####

variable "service_name" {
  description = "Name of the service."
  default     = "jenkins"
}

variable "service_annotations" {
  description = "Map of annotations that will be applied on the service."
  default     = {}
}

variable "service_labels" {
  description = "Map of labels that will be applied on the service."
  default     = {}
}

variable "enabled_localstorage" {
  type    = bool
  default = true
}

#####
# Ingress
#####

variable "ingress_enabled" {
  description = "Whether or not to enable the ingress."
  default     = true
}

variable "ingress_name" {
  description = "Name of the ingress."
  default     = "jenkins"
}

variable "ingress_annotations" {
  description = "Map of annotations that will be applied on the ingress."
  default     = {}
}

variable "ingress_labels" {
  description = "Map of labels that will be applied on the ingress."
  default     = {}
}

variable "ingress_host" {
  description = "Host on which the ingress wil be available (ex: nexus.example.com)."
  default     = "example.com"
}

variable "ingress_tls_enabled" {
  description = "Whether or not TLS should be enabled on the ingress."
  default     = true
}

variable "ingress_tls_secret_name" {
  description = "Name of the secret to use to put TLS on the ingress."
  default     = "jenkins"
}

variable "additionnal_ingress_paths" {
  description = <<-DOCUMENTATION
A list of map of additionnal ingress path to add. Map must support the following structure:
  * service_name (optional, string): The name of the kubernates service. (e.g. ssl-redirect)
  * service_port (optional, string): The service port number (e.g. use-annotation).
  * path (optional, string): The path to the service

For example, see folder examples/without-pvc.
DOCUMENTATION
  type        = list
  default     = []
}

variable "kubernetes_service" {
  description = "Name of the service."
  default     = "grafana"
}

variable "service_type" {
  description = "type of service"
  default     = {}
}

variable "service_account_name" {
  description = "name of the service account"
  default     = "grafana"
}

variable "service_account_annotations" {
  description = "Map of annotations that is merged on the service account."
  default     = {}
}

variable "service_account_labels" {
  description = "Map of labels that is merged on the service account."
  default     = {}
}

variable "config_map_name" {
  description = "Name of the config map that will be created."
  default     = "alertmanager-webhook-servicenow"
}

variable "config_map_annotations" {
  description = "Additionnal annotations that will be merged for the config map."
  default     = {}
}

variable "config_map_labels" {
  description = "Additionnal labels that will be merged for the config map."
  default     = {}
}

variable "configuration" {
  description = "Configuration to use for grafana (must be a yaml string)."
  type        = string
}

variable "secret_name" {
  description = "Name of the secret that will be created."
  default     = "grafana"
}

variable "secret_annotations" {
  description = "Additionnal annotations that will be merged for the secret."
  default     = {}
}

variable "secret_labels" {
  description = "Additionnal labels that will be merged for the secret."
  default     = {}
}

variable "grafana_secret" {
  description = "Secrets to use for grafana (must be a yaml string)."
  type        = string
}
