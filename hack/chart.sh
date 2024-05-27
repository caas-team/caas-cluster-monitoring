#!/bin/bash

# helm dependency update
tarball=$(ls charts/kube-prometheus-stack-*.tgz)
echo "Extracting ${tarball}"
if [ ! -d "charts/kube-prometheus-stack/" ]; then
    mkdir -p charts/kube-prometheus-stack/
fi
tar -xzf ${tarball} -C charts/

echo "Deleting CRD from kube-prometheus-stack"
rm -rf charts/kube-prometheus-stack/charts/crd/

echo "Packaging new chart"
helm package charts/kube-prometheus-stack -d charts

echo "Packaging caas-cluster-monitoring"
helm package .
