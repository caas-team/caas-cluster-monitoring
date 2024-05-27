charts:
	helm dependency update
	rm charts/hardenedKubelet-*.tgz
	rm charts/rke*.tgz

.PHONY: charts