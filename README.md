# CaaS Cluster Monitoring

## Installation

With de-installation of the origin Rancher Monitoring and CRDs

```bash
helm -n cattle-monitoring-system delete rancher-monitoring
helm -n cattle-monitoring-system delete rancher-monitoring-crd
helm -n cattle-monitoring-system upgrade -i rancher-monitoring .
```
 
