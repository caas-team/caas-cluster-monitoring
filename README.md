# CaaS Cluster Monitoring

## Installation

With de-installation of the origin Rancher Monitoring and keept resources

```bash
helm -n cattle-monitoring-system delete rancher-monitoring
kubectl -n cattle-monitoring-system delete secret alertmanager-rancher-monitoring-alertmanager
```

Deleting of rancher-monitoring-crd would delete also all corresponding Custom Resources. We delete only the Helm release secrets and keep CRDs into the cluster

```bash
kubectl -n cattle-monitoring-system get secrets -o name --no-headers | grep sh.helm.release.v1.rancher-monitoring-crd | xargs kubectl -n cattle-monitoring-system  delete $1
```

Nevertheless we need to upgrade CRDs manually because there is no logic to do this in Helm:

```bash
cd charts
tar xvfz kube-prometheus-stack-51.0.3.tgz
cd kube-prometheus-stack/charts/crds
kubectl apply -f crds/ --server-side --force-conflicts
```

To decouple CRDs from this chart (you may have installed CRDs from another chart or logic), feature is disabled:

```yaml
kube-prometheus-stack:
  crds:
    enabled: false
```

Upgrade to the kube-prometheus-stack:

```bash
helm -n cattle-monitoring-system upgrade -i rancher-monitoring .
```

available config parameters:

### caas

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `caas.clusterCosts` | bool | `true` | whether the cluster has kubecost installed |
| `caas.defaultEgress` | bool | `false` | whether the cluster needs defaultEgress  installed |
| `caas.dynatrace` | bool | `true` | whether the cluster has a dynatrace operator installed |
| `caas.fullnameOverride` | string | `""` |  |
| `caas.grafana.configmaps` | bool | `false` |  |
| `caas.nameOverride` | string | `""` |  |
| `caas.namespaceOverride` | string | `""` | overrides the default namespace for caas related resources |
| `caas.prometheusAuth` | bool | `true` | whether the cluster has Prometheus-Auth  installed |
| `caas.rbac.enabled` | bool | `true` | create a namespaces ServiceAccount |
| `caas.rbac.serviceAccount.create` | bool | `true` |  |
| `caas.rbac.serviceAccount.name` | string | `"rancher-monitoring"` |  |

### global

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `global.cattle.clusterId` | string | `"local"` |  |
| `global.cattle.clusterName` | string | `"local"` |  |
| `global.cattle.systemDefaultRegistry` | string | `"mtr.devops.telekom.de"` |  |
| `global.imageRegistry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.alertmanager.config.global.resolve_timeout` | string | `"5m"` |  |
| `kube-prometheus-stack.global.rbac.create` | bool | `true` |  |
| `kube-prometheus-stack.global.rbac.createAggregateClusterRoles` | bool | `false` |  |
| `kube-prometheus-stack.global.rbac.pspEnabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.multicluster.global.enabled` | bool | `false` |  |

### kube-prometheus-stack

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.alertmanagerConfigNamespaceSelector` | object | `{}` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.alertmanagerConfigSelector.matchExpressions[0].key` | string | `"release"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.alertmanagerConfigSelector.matchExpressions[0].operator` | string | `"In"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.alertmanagerConfigSelector.matchExpressions[0].values[0]` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.clusterAdvertiseAddress` | bool | `false` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.externalUrl` | string | `nil` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.forceEnableClusterMode` | bool | `false` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.image.repository` | string | `"kubeprometheusstack/alertmanager"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.image.tag` | string | `"v0.27.0"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.listenLocal` | bool | `false` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.logFormat` | string | `"logfmt"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.logLevel` | string | `"info"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.paused` | bool | `false` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.replicas` | int | `1` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.resources.limits.cpu` | string | `"800m"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.resources.limits.memory` | string | `"750Mi"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.resources.requests.cpu` | string | `"100m"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.resources.requests.memory` | string | `"200Mi"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.retention` | string | `"120h"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.routePrefix` | string | `"/"` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.securityContext.fsGroup` | int | `2000` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.securityContext.supplementalGroups[0]` | int | `1000` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.storage` | object | `{}` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.volumeMounts` | list | `[]` |  |
| `kube-prometheus-stack.alertmanager.alertmanagerSpec.volumes` | list | `[]` |  |
| `kube-prometheus-stack.alertmanager.apiVersion` | string | `"v2"` |  |
| `kube-prometheus-stack.alertmanager.config.global.resolve_timeout` | string | `"5m"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[0].equal[0]` | string | `"namespace"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[0].equal[1]` | string | `"alertname"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[0].source_matchers[0]` | string | `"severity = critical"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[0].target_matchers[0]` | string | `"severity =~ warning|info"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[1].equal[0]` | string | `"namespace"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[1].equal[1]` | string | `"alertname"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[1].source_matchers[0]` | string | `"severity = warning"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[1].target_matchers[0]` | string | `"severity = info"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[2].equal[0]` | string | `"namespace"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[2].source_matchers[0]` | string | `"alertname = InfoInhibitor"` |  |
| `kube-prometheus-stack.alertmanager.config.inhibit_rules[2].target_matchers[0]` | string | `"severity = info"` |  |
| `kube-prometheus-stack.alertmanager.config.receivers[0].name` | string | `"null"` |  |
| `kube-prometheus-stack.alertmanager.config.route.group_by[0]` | string | `"namespace"` |  |
| `kube-prometheus-stack.alertmanager.config.route.group_interval` | string | `"5m"` |  |
| `kube-prometheus-stack.alertmanager.config.route.group_wait` | string | `"30s"` |  |
| `kube-prometheus-stack.alertmanager.config.route.receiver` | string | `"null"` |  |
| `kube-prometheus-stack.alertmanager.config.route.repeat_interval` | string | `"12h"` |  |
| `kube-prometheus-stack.alertmanager.config.route.routes[0].matchers[0]` | string | `"alertname =~ \"InfoInhibitor|Watchdog\""` |  |
| `kube-prometheus-stack.alertmanager.config.route.routes[0].receiver` | string | `"null"` |  |
| `kube-prometheus-stack.alertmanager.config.templates[0]` | string | `"/etc/alertmanager/config/*.tmpl"` |  |
| `kube-prometheus-stack.alertmanager.enabled` | bool | `true` |  |
| `kube-prometheus-stack.alertmanager.service.annotations` | object | `{}` |  |
| `kube-prometheus-stack.alertmanager.service.clusterIP` | string | `""` |  |
| `kube-prometheus-stack.alertmanager.service.externalIPs` | list | `[]` |  |
| `kube-prometheus-stack.alertmanager.service.externalTrafficPolicy` | string | `"Cluster"` |  |
| `kube-prometheus-stack.alertmanager.service.labels` | object | `{}` |  |
| `kube-prometheus-stack.alertmanager.service.loadBalancerIP` | string | `""` |  |
| `kube-prometheus-stack.alertmanager.service.loadBalancerSourceRanges` | list | `[]` |  |
| `kube-prometheus-stack.alertmanager.service.port` | int | `9093` |  |
| `kube-prometheus-stack.alertmanager.service.targetPort` | int | `9093` |  |
| `kube-prometheus-stack.alertmanager.service.type` | string | `"ClusterIP"` |  |
| `kube-prometheus-stack.alertmanager.serviceAccount.create` | bool | `true` |  |
| `kube-prometheus-stack.alertmanager.serviceMonitor.interval` | string | `"30s"` |  |
| `kube-prometheus-stack.alertmanager.serviceMonitor.selfMonitor` | bool | `true` |  |
| `kube-prometheus-stack.alertmanager.servicePerReplica.enabled` | bool | `false` |  |
| `kube-prometheus-stack.alertmanager.templateFiles."rancher_defaults.tmpl"` | string | `"{{- define \"slack.rancher.text\" -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{ template \"rancher.text_multiple\" . }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- define \"webex.text_multiple\" -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- range .Alerts }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{ template \"webex.text_single\" . }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .ExternalURL }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line AlertManager: <{{ .ExternalURL }}> #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- define \"webex.text_single\" -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Labels.alertname }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line ## [ALERT - {{ .Labels.alertname }}] #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- else }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line ## [ALERT] #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Labels.severity }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line ### Severity: `{{ .Labels.severity }}` #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Labels.cluster }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line ### Cluster:  {{ .Labels.cluster }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.summary }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line ### Summary: {{ .Annotations.summary }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.message }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line Message:  {{ .Annotations.message }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.description }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line Description:  {{ .Annotations.description }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.runbook_url }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line Runbook URL: <{{ .Annotations.runbook_url }}|:spiral_note_pad:> #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Labels }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Remove (stringSlice \"alertname\" \"severity\" \"cluster\") }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if gt (len .) 0 }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line Additional Labels: #magic___^_^___line   {{- range .SortedPairs }} #magic___^_^___line   • {{ .Name }}: `{{ .Value }}` #magic___^_^___line   {{- end }} #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Annotations }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Remove (stringSlice \"summary\" \"message\" \"description\" \"runbook_url\") }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if gt (len .) 0 }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line ## Additional Annotations:* #magic___^_^___line   {{- range .SortedPairs }} #magic___^_^___line   • {{ .Name }}: `{{ .Value }}` #magic___^_^___line   {{- end }} #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- define \"rancher.text_multiple\" -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *[GROUP - Details]*  #magic___^_^___line       #magic___^_^___line #magic___^_^___line One or more alarms in this group have triggered a notification. #magic___^_^___line       #magic___^_^___line #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if gt (len .GroupLabels.Values) 0 }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Group Labels:* #magic___^_^___line   {{- range .GroupLabels.SortedPairs }} #magic___^_^___line   • *{{ .Name }}:* `{{ .Value }}` #magic___^_^___line   {{- end }} #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .ExternalURL }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Link to AlertManager:* {{ .ExternalURL }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- range .Alerts }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{ template \"rancher.text_single\" . }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- define \"rancher.text_single\" -}} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Labels.alertname }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *[ALERT - {{ .Labels.alertname }}]* #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- else }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *[ALERT]* #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Labels.severity }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Severity:* `{{ .Labels.severity }}` #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Labels.cluster }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Cluster:*  {{ .Labels.cluster }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.summary }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Summary:* {{ .Annotations.summary }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.message }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Message:* {{ .Annotations.message }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.description }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Description:* {{ .Annotations.description }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if .Annotations.runbook_url }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Runbook URL:* <{{ .Annotations.runbook_url }}|:spiral_note_pad:> #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Labels }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Remove (stringSlice \"alertname\" \"severity\" \"cluster\") }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if gt (len .) 0 }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Additional Labels:* #magic___^_^___line   {{- range .SortedPairs }} #magic___^_^___line   • *{{ .Name }}:* `{{ .Value }}` #magic___^_^___line   {{- end }} #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Annotations }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- with .Remove (stringSlice \"summary\" \"message\" \"description\" \"runbook_url\") }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- if gt (len .) 0 }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line *Additional Annotations:* #magic___^_^___line   {{- range .SortedPairs }} #magic___^_^___line   • *{{ .Name }}:* `{{ .Value }}` #magic___^_^___line   {{- end }} #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end }} #magic___^_^___line       #magic___^_^___line #magic___^_^___line {{- end -}}"` |  |
| `kube-prometheus-stack.coreDns.enabled` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.appNamespacesTarget` | string | `".*"` |  |
| `kube-prometheus-stack.defaultRules.create` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.alertmanager` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.configReloaders` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.etcd` | bool | `false` |  |
| `kube-prometheus-stack.defaultRules.rules.general` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.k8s` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeApiserverAvailability` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeApiserverBurnrate` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeApiserverHistogram` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeApiserverSlos` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeControllerManager` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubePrometheusGeneral` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubePrometheusNodeRecording` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeProxy` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeScheduler` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubeStateMetrics` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubelet` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubernetesApps` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubernetesResources` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubernetesStorage` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.kubernetesSystem` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.network` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.node` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.nodeExporterAlerting` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.nodeExporterRecording` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.prometheus` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.rules.prometheusOperator` | bool | `true` |  |
| `kube-prometheus-stack.defaultRules.runbookUrl` | string | `"https://runbooks.prometheus-operator.dev/runbooks"` |  |
| `kube-prometheus-stack.fullnameOverride` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.global.rbac.create` | bool | `true` |  |
| `kube-prometheus-stack.global.rbac.createAggregateClusterRoles` | bool | `false` |  |
| `kube-prometheus-stack.global.rbac.pspEnabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana."grafana.ini"."auth.anonymous".enabled` | bool | `true` |  |
| `kube-prometheus-stack.grafana."grafana.ini"."auth.anonymous".org_role` | string | `"Viewer"` |  |
| `kube-prometheus-stack.grafana."grafana.ini"."auth.basic".enabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana."grafana.ini".analytics.check_for_updates` | bool | `false` |  |
| `kube-prometheus-stack.grafana."grafana.ini".auth.disable_login_form` | bool | `false` |  |
| `kube-prometheus-stack.grafana."grafana.ini".log.level` | string | `"info"` |  |
| `kube-prometheus-stack.grafana."grafana.ini".security.allow_embedding` | bool | `true` | Required to embed dashboards in Rancher Cluster Overview Dashboard on Cluster Explorer |
| `kube-prometheus-stack.grafana."grafana.ini".users.auto_assign_org_role` | string | `"Viewer"` |  |
| `kube-prometheus-stack.grafana.adminPassword` | string | `"prom-operator"` |  |
| `kube-prometheus-stack.grafana.containerSecurityContext.allowPrivilegeEscalation` | bool | `false` |  |
| `kube-prometheus-stack.grafana.containerSecurityContext.capabilities.drop[0]` | string | `"ALL"` |  |
| `kube-prometheus-stack.grafana.containerSecurityContext.privileged` | bool | `false` |  |
| `kube-prometheus-stack.grafana.containerSecurityContext.readOnlyRootFilesystem` | bool | `true` |  |
| `kube-prometheus-stack.grafana.containerSecurityContext.runAsGroup` | int | `472` |  |
| `kube-prometheus-stack.grafana.containerSecurityContext.runAsUser` | int | `472` |  |
| `kube-prometheus-stack.grafana.createConfigmap` | bool | `true` |  |
| `kube-prometheus-stack.grafana.datasources."datasources.yaml".apiVersion` | int | `1` |  |
| `kube-prometheus-stack.grafana.datasources."datasources.yaml".datasources[0].access` | string | `"proxy"` |  |
| `kube-prometheus-stack.grafana.datasources."datasources.yaml".datasources[0].isDefault` | bool | `true` |  |
| `kube-prometheus-stack.grafana.datasources."datasources.yaml".datasources[0].name` | string | `"Prometheus"` |  |
| `kube-prometheus-stack.grafana.datasources."datasources.yaml".datasources[0].type` | string | `"prometheus"` |  |
| `kube-prometheus-stack.grafana.datasources."datasources.yaml".datasources[0].url` | string | `"http://prometheus-operated:9090"` |  |
| `kube-prometheus-stack.grafana.defaultDashboardsEnabled` | bool | `true` |  |
| `kube-prometheus-stack.grafana.defaultDashboardsTimezone` | string | `"utc"` |  |
| `kube-prometheus-stack.grafana.enabled` | bool | `true` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[0].emptyDir` | object | `{}` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[0].name` | string | `"nginx-home"` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[1].configMap.items[0].key` | string | `"nginx.conf"` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[1].configMap.items[0].mode` | int | `438` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[1].configMap.items[0].path` | string | `"nginx.conf"` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[1].configMap.name` | string | `"nginx-proxy-config-rancher-monitoring-grafana"` |  |
| `kube-prometheus-stack.grafana.extraContainerVolumes[1].name` | string | `"grafana-nginx"` |  |
| `kube-prometheus-stack.grafana.extraContainers` | string | `"- name: grafana-proxy\n  args:\n  - nginx\n  - -g\n  - daemon off;\n  - -c\n  - /nginx/nginx.conf\n  image: mtr.devops.telekom.de/kubeprometheusstack/nginx:1.23.2-alpine\n  ports:\n  - containerPort: 8080\n    name: nginx-http\n    protocol: TCP\n  resources:\n    limits:\n      cpu: 100m\n      memory: 100Mi\n    requests:\n      cpu: 50m\n      memory: 50Mi\n  securityContext:\n    allowPrivilegeEscalation: false\n    capabilities:\n      drop:\n      - ALL\n    privileged: false\n    runAsUser: 101\n    runAsGroup: 101\n    readOnlyRootFilesystem: true\n  volumeMounts:\n  - mountPath: /nginx\n    name: grafana-nginx\n  - mountPath: /var/cache/nginx\n    name: nginx-home\n"` |  |
| `kube-prometheus-stack.grafana.forceDeployDashboards` | bool | `true` |  |
| `kube-prometheus-stack.grafana.forceDeployDatasources` | bool | `true` |  |
| `kube-prometheus-stack.grafana.fullnameOverride` | string | `"rancher-monitoring-grafana"` |  |
| `kube-prometheus-stack.grafana.image.repository` | string | `"kubeprometheusstack/grafana"` |  |
| `kube-prometheus-stack.grafana.image.tag` | string | `"10.4.1"` |  |
| `kube-prometheus-stack.grafana.initChownData.enabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana.nameOverride` | string | `"rancher-monitoring-grafana"` |  |
| `kube-prometheus-stack.grafana.namespaceOverride` | string | `""` |  |
| `kube-prometheus-stack.grafana.rbac.create` | bool | `false` |  |
| `kube-prometheus-stack.grafana.rbac.namespaced` | bool | `true` |  |
| `kube-prometheus-stack.grafana.rbac.pspEnabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana.resources.limits.cpu` | string | `"600m"` |  |
| `kube-prometheus-stack.grafana.resources.limits.memory` | string | `"600Mi"` |  |
| `kube-prometheus-stack.grafana.resources.requests.cpu` | string | `"200m"` |  |
| `kube-prometheus-stack.grafana.resources.requests.memory` | string | `"200Mi"` |  |
| `kube-prometheus-stack.grafana.securityContext.fsGroup` | int | `472` |  |
| `kube-prometheus-stack.grafana.securityContext.runAsGroup` | int | `472` |  |
| `kube-prometheus-stack.grafana.securityContext.runAsUser` | int | `472` |  |
| `kube-prometheus-stack.grafana.securityContext.supplementalGroups[0]` | int | `472` |  |
| `kube-prometheus-stack.grafana.service.port` | int | `80` |  |
| `kube-prometheus-stack.grafana.service.portName` | string | `"nginx-http"` |  |
| `kube-prometheus-stack.grafana.service.targetPort` | int | `8080` |  |
| `kube-prometheus-stack.grafana.serviceAccount.create` | bool | `false` |  |
| `kube-prometheus-stack.grafana.serviceAccount.name` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.grafana.serviceMonitor.enabled` | bool | `true` |  |
| `kube-prometheus-stack.grafana.serviceMonitor.interval` | string | `"30s"` |  |
| `kube-prometheus-stack.grafana.serviceMonitor.path` | string | `"/metrics"` |  |
| `kube-prometheus-stack.grafana.serviceMonitor.scheme` | string | `"http"` |  |
| `kube-prometheus-stack.grafana.serviceMonitor.scrapeTimeout` | string | `"30s"` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.annotations` | object | `{}` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.enabled` | bool | `true` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.label` | string | `"grafana_dashboard"` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.labelValue` | string | `"1"` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.multicluster.etcd.enabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.multicluster.global.enabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.provider.allowUiUpdates` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.dashboards.searchNamespace` | string | `"cattle-monitoring-system"` |  |
| `kube-prometheus-stack.grafana.sidecar.datasources.createPrometheusReplicasDatasources` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.datasources.defaultDatasourceEnabled` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.datasources.enabled` | bool | `true` |  |
| `kube-prometheus-stack.grafana.sidecar.datasources.label` | string | `"grafana_datasource"` |  |
| `kube-prometheus-stack.grafana.sidecar.datasources.labelValue` | string | `"1"` |  |
| `kube-prometheus-stack.grafana.sidecar.datasources.searchNamespace` | string | `""` |  |
| `kube-prometheus-stack.grafana.sidecar.image.repository` | string | `"kubeprometheusstack/k8s-sidecar"` |  |
| `kube-prometheus-stack.grafana.sidecar.image.tag` | string | `"1.24.6"` |  |
| `kube-prometheus-stack.grafana.sidecar.plugins.searchNamespace` | string | `""` |  |
| `kube-prometheus-stack.grafana.sidecar.resources.limits.cpu` | string | `"100m"` |  |
| `kube-prometheus-stack.grafana.sidecar.resources.limits.memory` | string | `"100Mi"` |  |
| `kube-prometheus-stack.grafana.sidecar.resources.requests.cpu` | string | `"50m"` |  |
| `kube-prometheus-stack.grafana.sidecar.resources.requests.memory` | string | `"50Mi"` |  |
| `kube-prometheus-stack.grafana.sidecar.securityContext.allowPrivilegeEscalation` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.securityContext.capabilities.drop[0]` | string | `"ALL"` |  |
| `kube-prometheus-stack.grafana.sidecar.securityContext.privileged` | bool | `false` |  |
| `kube-prometheus-stack.grafana.sidecar.securityContext.readOnlyRootFilesystem` | bool | `true` |  |
| `kube-prometheus-stack.grafana.sidecar.securityContext.runAsGroup` | int | `472` |  |
| `kube-prometheus-stack.grafana.sidecar.securityContext.runAsUser` | int | `472` |  |
| `kube-prometheus-stack.grafana.testFramework.enabled` | bool | `false` |  |
| `kube-prometheus-stack.kube-state-metrics.honorLabels` | bool | `true` |  |
| `kube-prometheus-stack.kube-state-metrics.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.kube-state-metrics.image.repository` | string | `"kubeprometheusstack/kube-state-metrics"` |  |
| `kube-prometheus-stack.kube-state-metrics.image.tag` | string | `"v2.10.0"` |  |
| `kube-prometheus-stack.kube-state-metrics.prometheus.monitor.enabled` | bool | `true` |  |
| `kube-prometheus-stack.kube-state-metrics.prometheus.monitor.honorLabels` | bool | `true` |  |
| `kube-prometheus-stack.kube-state-metrics.rbac.create` | bool | `true` |  |
| `kube-prometheus-stack.kube-state-metrics.releaseLabel` | bool | `true` |  |
| `kube-prometheus-stack.kube-state-metrics.selfMonitor.enabled` | bool | `true` |  |
| `kube-prometheus-stack.kubeApiServer.enabled` | bool | `true` |  |
| `kube-prometheus-stack.kubeControllerManager.enabled` | bool | `false` |  |
| `kube-prometheus-stack.kubeDns.enabled` | bool | `false` |  |
| `kube-prometheus-stack.kubeEtcd.enabled` | bool | `false` |  |
| `kube-prometheus-stack.kubeProxy.enabled` | bool | `false` |  |
| `kube-prometheus-stack.kubeScheduler.enabled` | bool | `false` |  |
| `kube-prometheus-stack.kubeStateMetrics.enabled` | bool | `true` |  |
| `kube-prometheus-stack.kubelet.enabled` | bool | `true` |  |
| `kube-prometheus-stack.nameOverride` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.nodeExporter.enabled` | bool | `true` |  |
| `kube-prometheus-stack.nodeExporter.operatingSystems.darwin.enabled` | bool | `false` |  |
| `kube-prometheus-stack.prometheus-node-exporter.image.pullPolicy` | string | `"Always"` |  |
| `kube-prometheus-stack.prometheus-node-exporter.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.prometheus-node-exporter.image.repository` | string | `"kubeprometheusstack/node-exporter"` |  |
| `kube-prometheus-stack.prometheus-node-exporter.prometheus.monitor.enabled` | bool | `true` |  |
| `kube-prometheus-stack.prometheus-node-exporter.rbac.pspEnabled` | bool | `false` |  |
| `kube-prometheus-stack.prometheus-node-exporter.releaseLabel` | bool | `true` |  |
| `kube-prometheus-stack.prometheus-node-exporter.service.port` | int | `9796` |  |
| `kube-prometheus-stack.prometheus-node-exporter.service.targetPort` | int | `9796` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].apiGroups[0]` | string | `""` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[0]` | string | `"configmaps"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[1]` | string | `"namespaces"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[2]` | string | `"nodes"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[3]` | string | `"nodes/metrics"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[4]` | string | `"services"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[5]` | string | `"endpoints"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[6]` | string | `"pods"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].resources[7]` | string | `"secrets"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].verbs[0]` | string | `"get"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].verbs[1]` | string | `"list"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[0].verbs[2]` | string | `"watch"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[1].apiGroups[0]` | string | `"networking.k8s.io"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[1].resources[0]` | string | `"ingresses"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[1].verbs[0]` | string | `"get"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[1].verbs[1]` | string | `"list"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[1].verbs[2]` | string | `"watch"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[2].nonResourceURLs[0]` | string | `"/metrics"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[2].nonResourceURLs[1]` | string | `"/metrics/cadvisor"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[2].verbs[0]` | string | `"get"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].apiGroups[0]` | string | `"authentication.k8s.io"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].resources[0]` | string | `"tokenreviews"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].verbs[0]` | string | `"get"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].verbs[1]` | string | `"list"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].verbs[2]` | string | `"create"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].verbs[3]` | string | `"update"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].verbs[4]` | string | `"delete"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[3].verbs[5]` | string | `"watch"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].apiGroups[0]` | string | `"authorization.k8s.io"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].resources[0]` | string | `"subjectaccessreviews"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].verbs[0]` | string | `"get"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].verbs[1]` | string | `"list"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].verbs[2]` | string | `"create"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].verbs[3]` | string | `"update"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].verbs[4]` | string | `"delete"` |  |
| `kube-prometheus-stack.prometheus.additionalRulesForClusterRole[4].verbs[5]` | string | `"watch"` |  |
| `kube-prometheus-stack.prometheus.enabled` | bool | `true` |  |
| `kube-prometheus-stack.prometheus.ingress.annotations` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.ingress.enabled` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.ingress.hosts` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.ingress.labels` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.ingress.paths` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.ingress.tls` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.ingressPerReplica.enabled` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.additionalScrapeConfigs` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].args[0]` | string | `"--proxy-url=http://127.0.0.1:9090"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].args[1]` | string | `"--listen-address=$(POD_IP):9091"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].args[2]` | string | `"--filter-reader-labels=prometheus"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].args[3]` | string | `"--filter-reader-labels=prometheus_replica"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].args[4]` | string | `"--log.debug=true"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].command[0]` | string | `"prometheus-auth"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].env[0].name` | string | `"POD_IP"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].env[0].valueFrom.fieldRef.fieldPath` | string | `"status.podIP"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].image` | string | `"mtr.devops.telekom.de/caas/prometheus-auth:0.5.2"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].name` | string | `"prometheus-agent"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].ports[0].containerPort` | int | `9091` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].ports[0].name` | string | `"http-auth"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].ports[0].protocol` | string | `"TCP"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].resources.limits.cpu` | string | `"500m"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].resources.limits.memory` | string | `"500Mi"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].resources.requests.cpu` | string | `"100m"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.containers[0].resources.requests.memory` | string | `"500Mi"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.disableCompaction` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enableAdminAPI` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enableRemoteWriteReceiver` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enforcedLabelLimit` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enforcedLabelNameLengthLimit` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enforcedLabelValueLengthLimit` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enforcedNamespaceLabel` | string | `""` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enforcedSampleLimit` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.enforcedTargetLimit` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.evaluationInterval` | string | `"30s"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.excludedFromEnforcement` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.externalLabels` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.externalUrl` | string | `""` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.ignoreNamespaceSelectors` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.image.repository` | string | `"kubeprometheusstack/prometheus"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.image.tag` | string | `"v2.51.2"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.listenLocal` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.logFormat` | string | `"logfmt"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.logLevel` | string | `"info"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.overrideHonorLabels` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.overrideHonorTimestamps` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.paused` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.podAntiAffinityTopologyKey` | string | `"kubernetes.io/hostname"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.podMonitorNamespaceSelector` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.podMonitorSelector.matchExpressions[0].key` | string | `"release"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.podMonitorSelector.matchExpressions[0].operator` | string | `"In"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.podMonitorSelector.matchExpressions[0].values[0]` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.portName` | string | `"http-web"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.prometheusExternalLabelName` | string | `""` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.prometheusExternalLabelNameClear` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.prometheusRulesExcludedFromEnforce` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.query` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.queryLogFile` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.remoteRead` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.remoteWrite` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.remoteWriteDashboards` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.replicaExternalLabelName` | string | `""` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.replicaExternalLabelNameClear` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.replicas` | int | `1` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.resources.limits.cpu` | string | `"2000m"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.resources.limits.memory` | string | `"4000Mi"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.resources.requests.cpu` | string | `"400m"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.resources.requests.memory` | string | `"400Mi"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.retention` | string | `"10d"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.routePrefix` | string | `"/"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.ruleNamespaceSelector` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.ruleSelector.matchExpressions[0].key` | string | `"release"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.ruleSelector.matchExpressions[0].operator` | string | `"In"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.ruleSelector.matchExpressions[0].values[0]` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.scrapeInterval` | string | `"30s"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.scrapeTimeout` | string | `"10s"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.securityContext.fsGroup` | int | `2000` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.securityContext.supplementalGroups[0]` | int | `1000` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.serviceMonitorNamespaceSelector` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.serviceMonitorSelector.matchExpressions[0].key` | string | `"release"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.serviceMonitorSelector.matchExpressions[0].operator` | string | `"In"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.serviceMonitorSelector.matchExpressions[0].values[0]` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.shards` | int | `1` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.storageSpec` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.tsdb.outOfOrderTimeWindow` | string | `"0s"` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.volumeMounts` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.volumes` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.prometheusSpec.walCompression` | bool | `true` |  |
| `kube-prometheus-stack.prometheus.service.additionalPorts[0].name` | string | `"http-auth"` |  |
| `kube-prometheus-stack.prometheus.service.additionalPorts[0].port` | int | `9091` |  |
| `kube-prometheus-stack.prometheus.service.additionalPorts[0].protocol` | string | `"TCP"` |  |
| `kube-prometheus-stack.prometheus.service.additionalPorts[0].targetPort` | string | `"http-auth"` |  |
| `kube-prometheus-stack.prometheus.service.annotations` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.service.clusterIP` | string | `""` |  |
| `kube-prometheus-stack.prometheus.service.externalIPs` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.service.externalTrafficPolicy` | string | `"Cluster"` |  |
| `kube-prometheus-stack.prometheus.service.labels` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.service.port` | int | `9090` |  |
| `kube-prometheus-stack.prometheus.service.publishNotReadyAddresses` | bool | `false` |  |
| `kube-prometheus-stack.prometheus.service.targetPort` | int | `9090` |  |
| `kube-prometheus-stack.prometheus.service.type` | string | `"ClusterIP"` |  |
| `kube-prometheus-stack.prometheus.serviceAccount.create` | bool | `true` |  |
| `kube-prometheus-stack.prometheus.serviceAccount.name` | string | `"rancher-monitoring"` |  |
| `kube-prometheus-stack.prometheus.serviceMonitor.interval` | string | `"30s"` |  |
| `kube-prometheus-stack.prometheus.serviceMonitor.metricRelabelings` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.serviceMonitor.relabelings` | list | `[]` |  |
| `kube-prometheus-stack.prometheus.serviceMonitor.scheme` | string | `""` |  |
| `kube-prometheus-stack.prometheus.serviceMonitor.selfMonitor` | bool | `true` |  |
| `kube-prometheus-stack.prometheus.serviceMonitor.tlsConfig` | object | `{}` |  |
| `kube-prometheus-stack.prometheus.servicePerReplica.enabled` | bool | `false` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.image.pullPolicy` | string | `"Always"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.image.repository` | string | `"kubeprometheusstack/kube-webhook-certgen"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.image.tag` | string | `"v20221220-controller-v1.5.1-58-g787ea74b6"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.resources.limits.cpu` | string | `"300m"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.resources.limits.memory` | string | `"400Mi"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.resources.requests.cpu` | string | `"100m"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.resources.requests.memory` | string | `"100Mi"` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.securityContext.runAsGroup` | int | `2000` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.securityContext.runAsNonRoot` | bool | `true` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.securityContext.runAsUser` | int | `2000` |  |
| `kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.securityContext.seccompProfile.type` | string | `"RuntimeDefault"` |  |
| `kube-prometheus-stack.prometheusOperator.image.pullPolicy` | string | `"Always"` |  |
| `kube-prometheus-stack.prometheusOperator.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.prometheusOperator.image.repository` | string | `"kubeprometheusstack/prometheus-operator"` |  |
| `kube-prometheus-stack.prometheusOperator.image.tag` | string | `"v0.68.0"` |  |
| `kube-prometheus-stack.prometheusOperator.prometheusConfigReloader.image.registry` | string | `"mtr.devops.telekom.de"` |  |
| `kube-prometheus-stack.prometheusOperator.prometheusConfigReloader.image.repository` | string | `"kubeprometheusstack/prometheus-config-reloader"` |  |
| `kube-prometheus-stack.thanosRuler.enabled` | bool | `false` |  |

### rkeControllerManager

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rkeControllerManager.clients.https.enabled` | bool | `true` |  |
| `rkeControllerManager.clients.https.insecureSkipVerify` | bool | `true` |  |
| `rkeControllerManager.clients.https.useServiceAccountCredentials` | bool | `true` |  |
| `rkeControllerManager.clients.nodeSelector."node-role.kubernetes.io/controlplane"` | string | `"true"` |  |
| `rkeControllerManager.clients.port` | int | `10011` |  |
| `rkeControllerManager.clients.tolerations[0].effect` | string | `"NoExecute"` |  |
| `rkeControllerManager.clients.tolerations[0].operator` | string | `"Exists"` |  |
| `rkeControllerManager.clients.tolerations[1].effect` | string | `"NoSchedule"` |  |
| `rkeControllerManager.clients.tolerations[1].operator` | string | `"Exists"` |  |
| `rkeControllerManager.clients.useLocalhost` | bool | `true` |  |
| `rkeControllerManager.component` | string | `"kube-controller-manager"` |  |
| `rkeControllerManager.enabled` | bool | `false` |  |
| `rkeControllerManager.kubeVersionOverrides[0].constraint` | string | `"< 1.22"` |  |
| `rkeControllerManager.kubeVersionOverrides[0].values.clients.https.enabled` | bool | `false` |  |
| `rkeControllerManager.kubeVersionOverrides[0].values.clients.https.insecureSkipVerify` | bool | `false` |  |
| `rkeControllerManager.kubeVersionOverrides[0].values.clients.https.useServiceAccountCredentials` | bool | `false` |  |
| `rkeControllerManager.kubeVersionOverrides[0].values.metricsPort` | int | `10252` |  |
| `rkeControllerManager.metricsPort` | int | `10257` |  |

### rkeEtcd

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rkeEtcd.clients.https.authenticationMethod.authorization.enabled` | bool | `false` |  |
| `rkeEtcd.clients.https.authenticationMethod.bearerTokenFile.enabled` | bool | `false` |  |
| `rkeEtcd.clients.https.authenticationMethod.bearerTokenSecret.enabled` | bool | `false` |  |
| `rkeEtcd.clients.https.caCertFile` | string | `"kube-ca.pem"` |  |
| `rkeEtcd.clients.https.certDir` | string | `"/etc/kubernetes/ssl"` |  |
| `rkeEtcd.clients.https.certFile` | string | `"kube-etcd-*.pem"` |  |
| `rkeEtcd.clients.https.enabled` | bool | `true` |  |
| `rkeEtcd.clients.https.keyFile` | string | `"kube-etcd-*-key.pem"` |  |
| `rkeEtcd.clients.https.seLinuxOptions.type` | string | `"rke_kubereader_t"` |  |
| `rkeEtcd.clients.nodeSelector."node-role.kubernetes.io/etcd"` | string | `"true"` |  |
| `rkeEtcd.clients.port` | int | `10014` |  |
| `rkeEtcd.clients.tolerations[0].effect` | string | `"NoExecute"` |  |
| `rkeEtcd.clients.tolerations[0].operator` | string | `"Exists"` |  |
| `rkeEtcd.clients.tolerations[1].effect` | string | `"NoSchedule"` |  |
| `rkeEtcd.clients.tolerations[1].operator` | string | `"Exists"` |  |
| `rkeEtcd.component` | string | `"kube-etcd"` |  |
| `rkeEtcd.enabled` | bool | `false` |  |
| `rkeEtcd.metricsPort` | int | `2379` |  |

### rkeIngressNginx

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rkeIngressNginx.clients.nodeSelector."node-role.kubernetes.io/worker"` | string | `"true"` |  |
| `rkeIngressNginx.clients.port` | int | `10015` |  |
| `rkeIngressNginx.clients.tolerations[0].effect` | string | `"NoExecute"` |  |
| `rkeIngressNginx.clients.tolerations[0].operator` | string | `"Exists"` |  |
| `rkeIngressNginx.clients.tolerations[1].effect` | string | `"NoSchedule"` |  |
| `rkeIngressNginx.clients.tolerations[1].operator` | string | `"Exists"` |  |
| `rkeIngressNginx.clients.useLocalhost` | bool | `true` |  |
| `rkeIngressNginx.component` | string | `"ingress-nginx"` |  |
| `rkeIngressNginx.enabled` | bool | `false` |  |
| `rkeIngressNginx.metricsPort` | int | `10254` |  |

### rkeProxy

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rkeProxy.clients.port` | int | `10013` |  |
| `rkeProxy.clients.tolerations[0].effect` | string | `"NoExecute"` |  |
| `rkeProxy.clients.tolerations[0].operator` | string | `"Exists"` |  |
| `rkeProxy.clients.tolerations[1].effect` | string | `"NoSchedule"` |  |
| `rkeProxy.clients.tolerations[1].operator` | string | `"Exists"` |  |
| `rkeProxy.clients.useLocalhost` | bool | `true` |  |
| `rkeProxy.component` | string | `"kube-proxy"` |  |
| `rkeProxy.enabled` | bool | `false` |  |
| `rkeProxy.metricsPort` | int | `10249` |  |

### rkeScheduler

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `rkeScheduler.clients.https.authenticationMethod.authorization.enabled` | bool | `false` |  |
| `rkeScheduler.clients.https.authenticationMethod.bearerTokenFile.enabled` | bool | `false` |  |
| `rkeScheduler.clients.https.authenticationMethod.bearerTokenSecret.enabled` | bool | `false` |  |
| `rkeScheduler.clients.https.enabled` | bool | `true` |  |
| `rkeScheduler.clients.https.insecureSkipVerify` | bool | `true` |  |
| `rkeScheduler.clients.https.useServiceAccountCredentials` | bool | `true` |  |
| `rkeScheduler.clients.nodeSelector."node-role.kubernetes.io/controlplane"` | string | `"true"` |  |
| `rkeScheduler.clients.port` | int | `10012` |  |
| `rkeScheduler.clients.tolerations[0].effect` | string | `"NoExecute"` |  |
| `rkeScheduler.clients.tolerations[0].operator` | string | `"Exists"` |  |
| `rkeScheduler.clients.tolerations[1].effect` | string | `"NoSchedule"` |  |
| `rkeScheduler.clients.tolerations[1].operator` | string | `"Exists"` |  |
| `rkeScheduler.clients.useLocalhost` | bool | `true` |  |
| `rkeScheduler.component` | string | `"kube-scheduler"` |  |
| `rkeScheduler.enabled` | bool | `false` |  |
| `rkeScheduler.kubeVersionOverrides[0].constraint` | string | `"< 1.23"` |  |
| `rkeScheduler.kubeVersionOverrides[0].values.clients.https.enabled` | bool | `false` |  |
| `rkeScheduler.kubeVersionOverrides[0].values.clients.https.insecureSkipVerify` | bool | `false` |  |
| `rkeScheduler.kubeVersionOverrides[0].values.clients.https.useServiceAccountCredentials` | bool | `false` |  |
| `rkeScheduler.kubeVersionOverrides[0].values.metricsPort` | int | `10251` |  |
| `rkeScheduler.metricsPort` | int | `10259` |  |

### hardenedKubelet

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `hardenedKubelet.clients.https.authenticationMethod.authorization.enabled` | bool | `false` |  |
| `hardenedKubelet.clients.https.authenticationMethod.bearerTokenFile.enabled` | bool | `false` |  |
| `hardenedKubelet.clients.https.authenticationMethod.bearerTokenSecret.enabled` | bool | `false` |  |
| `hardenedKubelet.clients.https.enabled` | bool | `true` |  |
| `hardenedKubelet.clients.https.insecureSkipVerify` | bool | `true` |  |
| `hardenedKubelet.clients.https.useServiceAccountCredentials` | bool | `true` |  |
| `hardenedKubelet.clients.port` | int | `10015` |  |
| `hardenedKubelet.clients.rbac.additionalRules[0].nonResourceURLs[0]` | string | `"/metrics/cadvisor"` |  |
| `hardenedKubelet.clients.rbac.additionalRules[0].verbs[0]` | string | `"get"` |  |
| `hardenedKubelet.clients.rbac.additionalRules[1].apiGroups[0]` | string | `""` |  |
| `hardenedKubelet.clients.rbac.additionalRules[1].resources[0]` | string | `"nodes/metrics"` |  |
| `hardenedKubelet.clients.rbac.additionalRules[1].verbs[0]` | string | `"get"` |  |
| `hardenedKubelet.clients.tolerations[0].effect` | string | `"NoExecute"` |  |
| `hardenedKubelet.clients.tolerations[0].operator` | string | `"Exists"` |  |
| `hardenedKubelet.clients.tolerations[1].effect` | string | `"NoSchedule"` |  |
| `hardenedKubelet.clients.tolerations[1].operator` | string | `"Exists"` |  |
| `hardenedKubelet.clients.useLocalhost` | bool | `true` |  |
| `hardenedKubelet.component` | string | `"kubelet"` |  |
| `hardenedKubelet.enabled` | bool | `false` |  |
| `hardenedKubelet.metricsPort` | int | `10250` |  |
| `hardenedKubelet.serviceMonitor.bearerTokenFile` | string | `"/var/run/secrets/kubernetes.io/serviceaccount/token"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[0].honorLabels` | bool | `true` |  |
| `hardenedKubelet.serviceMonitor.endpoints[0].port` | string | `"metrics"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[0].relabelings[0].sourceLabels[0]` | string | `"__metrics_path__"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[0].relabelings[0].targetLabel` | string | `"metrics_path"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[1].honorLabels` | bool | `true` |  |
| `hardenedKubelet.serviceMonitor.endpoints[1].path` | string | `"/metrics/cadvisor"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[1].port` | string | `"metrics"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[1].relabelings[0].sourceLabels[0]` | string | `"__metrics_path__"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[1].relabelings[0].targetLabel` | string | `"metrics_path"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[2].honorLabels` | bool | `true` |  |
| `hardenedKubelet.serviceMonitor.endpoints[2].path` | string | `"/metrics/probes"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[2].port` | string | `"metrics"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[2].relabelings[0].sourceLabels[0]` | string | `"__metrics_path__"` |  |
| `hardenedKubelet.serviceMonitor.endpoints[2].relabelings[0].targetLabel` | string | `"metrics_path"` |  |

Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
