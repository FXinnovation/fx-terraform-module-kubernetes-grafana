# terraform-module-multi-template

Template repository for public terraform modules

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| aws | >= 3.0 |
| kubernetes | >= 2.0 |
| random | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 2.0 |
| random | >= 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [kubernetes_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0/docs/resources/deployment) |
| [kubernetes_service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0/docs/resources/service) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/3.0/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotations | Map of annotations that will be merged with all other annotations on all kubernetes resources. | `map` | `{}` | no |
| cpu\_limits | n/a | `any` | n/a | yes |
| cpu\_requests | n/a | `any` | n/a | yes |
| deployment\_name | n/a | `string` | `"grafana"` | no |
| enable\_localstorage | n/a | `bool` | n/a | yes |
| enabled\_datasources | n/a | `bool` | n/a | yes |
| grafana\_node\_port | n/a | `any` | n/a | yes |
| grafana\_persistent\_volume\_claim\_storage | n/a | `any` | n/a | yes |
| grafana\_service\_type | n/a | `any` | n/a | yes |
| image | n/a | `any` | n/a | yes |
| image\_id | n/a | `any` | n/a | yes |
| kubernetes\_service | n/a | `any` | n/a | yes |
| labels | Map of labels that will be merged with all other labels on all kubernetes resource. | `map` | `{}` | no |
| mem\_limits | n/a | `any` | n/a | yes |
| mem\_requests | n/a | `any` | n/a | yes |
| namespace\_annotations | Map of annotations to apply to the namespace. | `map` | `{}` | no |
| namespace\_labels | Map of labels to apply to the namespace. | `map` | `{}` | no |
| namespace\_name | Name of the namespace to create and deploy the grafana. | `string` | `"grafana"` | no |
| replica | n/a | `any` | n/a | yes |
| service\_node\_port | n/a | `any` | n/a | yes |
| storage\_class\_name | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| password | n/a |
| username | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.

## Usage

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
