# NGINX Ingress Controller with Cloud66

1. Create a stack on Cloud66, note down the namespace.
2. Edit the namespace field in `ingress-controller.yml` file and run 
   `kubectl apply -f ingress-controller.yml`.
2. Copy the contents of secret `ingress-nginx-admission` (`ca`, `cert`, `key`) 
   with tag `secret=webhook-cert`.
3. Deploy the services.yml into C66.
