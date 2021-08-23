# NGINX Ingress Controller with Cloud66

1. Create a stack on Cloud66, note down the namespace.
2. Run `kubectl apply -f ingress-controller.yml` - with the right namespace.
2. Copy the secret contents (`ca`, `cert`, `key`) into the Application 
   Configstore and then reference this for the nginx ingress service, use 
   `name=nginx-ingress-controller` as metadata
3. Deploy the services.yml into C66.
