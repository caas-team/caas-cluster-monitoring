#!/bin/bash

helm dependency update
tarball=$(ls charts/kube-prometheus-stack-*.tgz)
echo "Extracting ${tarball}"
tar -xzf ${tarball} -C charts/

echo "Deleting CRD from kube-prometheus-stack"
rm -rf charts/kube-prometheus-stack/charts/crds/
yq 'del(.dependencies[] | select(.name == "crds"))' -i charts/kube-prometheus-stack/Chart.yaml

echo "Packaging new chart"
helm package charts/kube-prometheus-stack -d charts

echo "Packaging caas-cluster-monitoring"
helm package .
