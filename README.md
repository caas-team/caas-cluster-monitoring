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
 
