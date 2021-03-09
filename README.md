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
| [kubernetes_config_map](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) |
| [kubernetes_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) |
| [kubernetes_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) |
| [kubernetes_persistent_volume_claim](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) |
| [kubernetes_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) |
| [kubernetes_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additionnal\_ingress\_paths | A list of map of additionnal ingress path to add. Map must support the following structure:<br>  * service\_name (optional, string): The name of the kubernates service. (e.g. ssl-redirect)<br>  * service\_port (optional, string): The service port number (e.g. use-annotation).<br>  * path (optional, string): The path to the service<br><br>For example, see folder examples/without-pvc. | `list` | `[]` | no |
| annotations | Map of annotations that will be merged with all other annotations on all kubernetes resources. | `map` | `{}` | no |
| config\_map\_annotations | Additionnal annotations that will be merged for the config map. | `map` | `{}` | no |
| config\_map\_labels | Additionnal labels that will be merged for the config map. | `map` | `{}` | no |
| config\_map\_name | Name of the config map that will be created. | `string` | `"grafana"` | no |
| configuration | Configuration to use for grafana (must be a yaml string). | `map(string)` | `{}` | no |
| deployment\_annotations | Additionnal annotations that will be merged on the deployment. | `map` | `{}` | no |
| deployment\_labels | Additionnal labels that will be merged on the deployment. | `map` | `{}` | no |
| deployment\_name | Name of the deployment that will be create. | `string` | `"grafana"` | no |
| deployment\_template\_labels | Map of annotations to apply to the namespace. | `map` | `{}` | no |
| enabled\_localstorage | n/a | `bool` | `true` | no |
| grafana\_secret | Secrets to use for grafana (must be a yaml string). | `map(string)` | `{}` | no |
| image | Image to use. | `string` | `"grafana/grafana"` | no |
| image\_version | Version of the image to use. | `string` | `"5.4.3"` | no |
| ingress\_annotations | Map of annotations that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_enabled | Whether or not to enable the ingress. | `bool` | `true` | no |
| ingress\_host | Host on which the ingress wil be available (ex: nexus.example.com). | `string` | `"example.com"` | no |
| ingress\_labels | Map of labels that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_name | Name of the ingress. | `string` | `"grafana"` | no |
| ingress\_tls\_enabled | Whether or not TLS should be enabled on the ingress. | `bool` | `true` | no |
| ingress\_tls\_secret\_name | Name of the secret to use to put TLS on the ingress. | `string` | `"grafana"` | no |
| kubernetes\_service | Name of the service. | `string` | `"grafana"` | no |
| labels | Map of labels that will be merged with all other labels on all kubernetes resource. | `map` | `{}` | no |
| namespace | Namespace in which the module will be deployed. | `string` | `"grafana"` | no |
| pvc\_name | Name of the PVC for gradfana | `string` | `"grafana"` | no |
| pvc\_storage | Name of the PVC for gradfana | `string` | `"10Gb"` | no |
| pvc\_storage\_class\_name | Name of the PVC for gradfana | `string` | `"grafana"` | no |
| replicas | Number of replicas to deploy. | `number` | `1` | no |
| resources\_limits\_cpu | Amount of cpu time that the application limits. | `string` | `"2"` | no |
| resources\_limits\_memory | Amount of memory that the application limits. | `string` | `"4096Mi"` | no |
| resources\_requests\_cpu | Amount of cpu time that the application requests. | `string` | `"1"` | no |
| resources\_requests\_memory | Amount of memory that the application requests. | `string` | `"2048Mi"` | no |
| secret\_annotations | Additionnal annotations that will be merged for the secret. | `map` | `{}` | no |
| secret\_labels | Additionnal labels that will be merged for the secret. | `map` | `{}` | no |
| secret\_name | Name of the secret that will be created. | `string` | `"grafana"` | no |
| service\_account\_annotations | Map of annotations that is merged on the service account. | `map` | `{}` | no |
| service\_account\_labels | Map of labels that is merged on the service account. | `map` | `{}` | no |
| service\_account\_name | name of the service account | `string` | `"grafana"` | no |
| service\_annotations | Map of annotations that will be applied on the service. | `map` | `{}` | no |
| service\_labels | Map of labels that will be applied on the service. | `map` | `{}` | no |
| service\_name | Name of the service. | `string` | `"grafana"` | no |
| service\_type | type of service | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_map | n/a |
| deployment | n/a |
| ingress | n/a |
| secret | n/a |
| service | n/a |
| service\_account | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.
