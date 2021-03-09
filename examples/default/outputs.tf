#####
# deployment
#####
output "deployment" {
  value = module.this.deployment
}
#####
# Service
#####
output "service" {
  value = module.this.service
}
output "secret" {
  value     = module.this.secret
  sensitive = true
}
output "service_account" {
  value = module.this.service_account
}
