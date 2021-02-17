# terraform-module-multi-template

Template repository for public terraform modules

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Error: no lines in file
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.

##Usage

module "grafana" {
  #https://github.com/grafana/grafana
  source = "https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-kubernetes-grafana"
  # grafana_ingress_host = var.grafana_ingress_host
  monitoring_name_space = var.monitoring_name_space
  grafana_service_type = var.grafana_service_type
  grafana_replica = var.grafana_replica
  grafana_node_port = var.grafana_node_port
  grafana_persistent_volume_claim_storage = var.grafana_persistent_volume_claim_storage
  storage_class_name= var.storage_class_name

}
