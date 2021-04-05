
output "deployment" {
  value = kubernetes_deployment.this
}

output "ingress" {
  value = kubernetes_ingress.this
}

output "service" {
  value = kubernetes_service.this
}

output "secret" {
  value     = kubernetes_secret.this
  sensitive = true
}

output "service_account" {
  value = kubernetes_service_account.this
}

output "environment_config_map" {
  value = kubernetes_config_map.environment
}

output "files_config_map" {
  value = kubernetes_config_map.files
}
