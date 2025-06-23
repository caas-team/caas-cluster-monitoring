chart:
	./hack/chart.sh

lint:
	helm lint ./

.PHONY: chart
