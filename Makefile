chart:
	./hack/chart.sh

lint:
	helm lint ./
	# also lint all charts in the charts directory
	helm lint ./charts/*
.PHONY: chart

