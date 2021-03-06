# terraform-module-multi-template

Template repository for public terraform modules

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| kubernetes | >= 1.10.0 |
| random | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.10.0 |
| random | >= 2.0 |

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
| additionnal\_ingress\_paths | A list of map of additionnal ingress path to add. Map must support the following structure:<br>  * service\_name (optional, string): The name of the kubernates service. (e.g. ssl-redirect)<br>  * service\_port (optional, string): The service port number (e.g. use-annotation).<br>  * path (optional, string): The path to the service<br><br>For example, see folder examples/without-pvc. | `list(any)` | `[]` | no |
| annotations | Map of annotations that will be merged with all other annotations on all kubernetes resources. | `map(string)` | `{}` | no |
| config\_map\_annotations | Additionnal annotations that will be merged for the config map. | `map(string)` | `{}` | no |
| config\_map\_labels | Additionnal labels that will be merged for the config map. | `map(string)` | `{}` | no |
| config\_map\_name\_prefix | Prefix of the config maps that will be created. | `string` | `"grafana"` | no |
| configuration | Configuration to use for grafana, all the key pairs will be mounted as env variables not as a file | `map(string)` | `{}` | no |
| deployment\_annotations | Additionnal labels that will be merged on the deployment. | `map(string)` | `{}` | no |
| deployment\_name | Name of the deployment that will be create. | `string` | `"grafana"` | no |
| deployment\_template\_annotations | Additionnal annotations that will be merged on the deployment. | `map(string)` | `{}` | no |
| deployment\_template\_labels | Map of annotations to apply to the namespace. | `map(string)` | `{}` | no |
| deploymnet\_labels | deploymnet labels  that will be merged for the deployment. | `map(string)` | `{}` | no |
| enabled\_localstorage | should local storage be enabled for grafana | `bool` | `true` | no |
| enabled\_security\_context | should security contect be enabled for grafana pods | `bool` | `false` | no |
| image | Image to use. | `string` | `"grafana/grafana"` | no |
| image\_version | Version of the image to use. | `string` | `"latest"` | no |
| ingress\_annotations | Map of annotations that will be applied on the ingress. | `map(string)` | `{}` | no |
| ingress\_enabled | Whether or not to enable the ingress. | `bool` | `true` | no |
| ingress\_host | Host on which the ingress wil be available (ex: grafana.example.com). | `string` | `"grafana.example.com"` | no |
| ingress\_labels | Map of labels that will be applied on the ingress. | `map(string)` | `{}` | no |
| ingress\_name | Name of the ingress. | `string` | `"grafana"` | no |
| ingress\_tls\_enabled | Whether or not TLS should be enabled on the ingress. | `bool` | `true` | no |
| ingress\_tls\_secret\_name | Name of the secret to use to put TLS on the ingress. | `string` | `"grafana"` | no |
| labels | Map of labels that will be merged with all other labels on all kubernetes resource. | `map(string)` | `{}` | no |
| ldap\_configuration | Content of the ldap.toml file that will be used for ldap configuration. (LDAP needs to be enabled in the configuration to take effect.) | `string` | `""` | no |
| namespace | Namespace in which the module will be deployed. | `string` | `"grafana"` | no |
| pvc\_access\_modes | A set of the desired access modes the volume should have. | `list(string)` | <pre>[<br>  "ReadWriteOnce"<br>]</pre> | no |
| pvc\_annotations | Map of annotations that will be applied on the ingress. | `map(string)` | `{}` | no |
| pvc\_labels | Map of labels that will be applied on the ingress. | `map(string)` | `{}` | no |
| pvc\_name | Name of the PVC for gradfana | `string` | `"grafana"` | no |
| pvc\_storage | storage required for pvc | `string` | `"10Gi"` | no |
| pvc\_storage\_class\_name | Name of the storage class that will be applied to persistent volume claim. | `string` | `null` | no |
| pvc\_volume\_name | Name of the volume bound to the persistent volume claim. | `string` | `""` | no |
| pvc\_wait\_until\_bound | Whether to wait for the claim to reach Bound state (to find volume in which to claim the space) | `bool` | `false` | no |
| replicas | Number of replicas to deploy. | `number` | `1` | no |
| resources\_limits\_cpu | Amount of cpu time that the application limits. | `string` | `"500m"` | no |
| resources\_limits\_memory | Amount of memory that the application limits. | `string` | `"512Mi"` | no |
| resources\_requests\_cpu | Amount of cpu time that the application requests. | `string` | `"100m"` | no |
| resources\_requests\_memory | Amount of memory that the application requests. | `string` | `"256Mi"` | no |
| secret\_annotations | Additionnal annotations that will be merged for the secret. | `map(string)` | `{}` | no |
| secret\_configuration | should contain grafana secret env variables, see the example below<br>  For example, {<br>  { "GF\_SECURITY\_ADMIN\_PASSWORD" = "xxxxx" }<br>} | `map(string)` | `{}` | no |
| secret\_labels | Additionnal labels that will be merged for the secret. | `map(string)` | `{}` | no |
| secret\_name | Name of the secret that will be created. | `string` | `"grafana"` | no |
| security\_context\_fs\_group | when fsGroup field is specified, all processes of the container are also part of the supplementary group ID given | `string` | `"2000"` | no |
| service\_account\_annotations | Map of annotations that is merged on the service account. | `map(string)` | `{}` | no |
| service\_account\_labels | Map of labels that is merged on the service account. | `map(string)` | `{}` | no |
| service\_account\_name | name of the service account | `string` | `"grafana"` | no |
| service\_annotations | Map of annotations that will be applied on the service. | `map(string)` | `{}` | no |
| service\_labels | Map of labels that will be applied on the service. | `map(string)` | `{}` | no |
| service\_name | Name of the service. | `string` | `"grafana"` | no |
| service\_type | type of service | `string` | `"ClusterIP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| deployment | n/a |
| environment\_config\_map | n/a |
| files\_config\_map | n/a |
| ingress | n/a |
| secret | n/a |
| service | n/a |
| service\_account | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning

This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks

This repository uses [pre-commit](https://pre-commit.com/) hooks.
