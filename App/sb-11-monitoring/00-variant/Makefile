all: apply

apply:
	kubectl apply -f ./91-pv.yaml
	kubectl apply -f ./02-all-in-pod-without-exporter.yaml
	kubectl apply -f ./92-ingress.yaml

delete:
	kubectl delete -f ./92-ingress.yaml || true
	kubectl delete -f ./02-all-in-pod-without-exporter.yaml || true
	kubectl delete -f ./11-pv.yaml || true
