chart:
	helm dependency update
	rm charts/hardenedKubelet-*.tgz
	rm charts/rke*.tgz
	helm package .

.PHONY: chart