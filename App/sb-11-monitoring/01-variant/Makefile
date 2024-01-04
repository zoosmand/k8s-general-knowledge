all: apply

apply:
	kubectl apply -f ./00-pv.yaml
	#kubectl apply -f ./01-namespace.yaml
	kubectl apply -f ./02-service-account.yaml
	kubectl apply -f ./03-configmap.yaml
	kubectl apply -f ./04-persistent-volume-claim.yaml
	kubectl apply -f ./05-testing-pod.yaml
	kubectl apply -f ./06-prometheus.yaml
	kubectl apply -f ./07-pushgateway.yaml
	kubectl apply -f ./08-alertmanager.yaml
	kubectl apply -f ./09-grafana.yaml
	kubectl apply -f ./10-hooker.yaml
	kubectl apply -f ./11-pushgateway-test.yaml
	kubectl apply -f ./12-alertmanager-test.yaml
	kubectl apply -f ./13-ingress.yaml
	# kubectl create secret tls sb-11-grafana-tls --cert=../../Docker/Letsencrypt/files/v1/letsencrypt/grafana/live/grafana.askug.net/fullchain.pem --key=../../Docker/Letsencrypt/files/v1/letsencrypt/grafana/live/grafana.askug.net/privkey.pem -n monitoring
	# kubectl create secret tls sb-11-hooker-tls --cert=../../Docker/Letsencrypt/files/v1/letsencrypt/hooker/live/hooker.askug.net/fullchain.pem --key=../../Docker/Letsencrypt/files/v1/letsencrypt/hooker/live/hooker.askug.net/privkey.pem -n monitoring
	# kubectl create secret generic sb-11-monitoring-secrets --from-literal=telegram.token=$$TELEGRAM_TOKEN --from-literal=email.password=$$EMAIL_PASSWORD

delete:
	kubectl delete -f ./13-ingress.yaml || true
	kubectl delete -f ./12-alertmanager-test.yaml || true
	kubectl delete -f ./11-pushgateway-test.yaml || true
	kubectl delete -f ./10-hooker.yaml || true
	kubectl delete -f ./09-grafana.yaml || true
	kubectl delete -f ./08-alertmanager.yaml || true
	kubectl delete -f ./07-pushgateway.yaml || true
	kubectl delete -f ./06-prometheus.yaml || true
	kubectl delete -f ./05-testing-pod.yaml || true
	kubectl delete -f ./04-persistent-volume-claim.yaml || true
	kubectl delete -f ./03-configmap.yaml || true
	kubectl delete -f ./02-service-account.yaml || true
	kubectl delete -f ./00-pv.yaml || true
