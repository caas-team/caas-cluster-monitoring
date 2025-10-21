# Project ID Based Kubernetes Monitoring Rules

This feature allows filtering both Kubernetes recording rules and alerting rules to only process namespaces belonging to specific Rancher projects. This includes:

- **Recording rules**: Container CPU, memory, resource limits/requests, and pod ownership
- **Alerting rules**: Pod crashes, readiness issues, deployment problems, and storage alerts

## Configuration

In `values.yaml`:

```yaml
caas:
  customRules:
    projectFiltering:
      enabled: true
      labelKey: "field.cattle.io/projectId"
      labelValues:
        - "caas-operations"
        - "caas-monitoring"
        # Note: p-gsqsz removed as it's cluster-specific (s13)
      additionalNamespaces:
        - "caas-eck-operator"
        - "nginx"
        # Cluster-specific namespaces (formerly under p-gsqsz project)
        - "kube-system"
        - "calico-system"
        - "cattle-fleet-system"
        - "cattle-system"
```

## How it Works

1. **Label Transformation**: The label key `field.cattle.io/projectId` becomes `field_cattle_io_projectId` in kube-state-metrics
2. **Multiple Values**: The `labelValues` list is joined with `|` to create a regex pattern like `caas-operations|caas-monitoring|p-gsqsz`
3. **Additional Namespaces**: Namespaces listed in `additionalNamespaces` are included regardless of project ID
4. **Prometheus Query**: Uses `=~` regex matching to filter namespaces by project ID OR namespace name

## Generated Recording Rules

### Container CPU Usage
- `node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate_labeled`
- `node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate5m_labeled`

### Container Memory
- `node_namespace_pod_container:container_memory_cache_labeled`
- `node_namespace_pod_container:container_memory_rss_labeled`
- `node_namespace_pod_container:container_memory_swap_labeled`
- `node_namespace_pod_container:container_memory_working_set_bytes_labeled`

### Container Resources
- `cluster_namespace_pod_container:kube_pod_container_resource_requests_memory_bytes_labeled`
- `cluster_namespace_pod_container:kube_pod_container_resource_requests_cpu_cores_labeled`
- `cluster_namespace_pod_container:kube_pod_container_resource_limits_memory_bytes_labeled`
- `cluster_namespace_pod_container:kube_pod_container_resource_limits_cpu_cores_labeled`

### Pod Ownership
- `namespace_workload_pod:kube_pod_owner:relabel_labeled`

## Generated Alerting Rules

### Kubernetes Apps Alerts
- `KubePodCrashLooping` - Only alerts for pods in monitored projects
- `KubePodNotReady` - Only alerts for pods in monitored projects  
- `KubeDeploymentGenerationMismatch` - Only alerts for deployments in monitored projects

### Kubernetes Storage Alerts
- `KubePersistentVolumeFillingUp` - Only alerts for PVs in monitored projects
- `KubePersistentVolumeInodesFillingUp` - Only alerts for PV inodes in monitored projects

## Finding Project IDs

To see all project IDs in your cluster:

```bash
kubectl get namespaces -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.labels.field\.cattle\.io/projectId}{"\n"}{end}' | grep -v '<no value>'
```

## Benefits

- **Significant performance improvement**: Reduces computational load by only processing selected projects across all k8s recording rules
- **Comprehensive coverage**: Filters CPU, memory, resource, and pod ownership rules consistently
- **Dashboard compatibility**: Maintains compatibility with existing dashboards (using the `_labeled` suffix)
- **Flexible configuration**: Easily add/remove projects from monitoring
- **Resource efficiency**: Reduces Prometheus rule evaluation time and storage requirements
- **Cluster portability**: Cluster-specific project IDs moved to additionalNamespaces for better portability
