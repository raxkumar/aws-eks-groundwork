# Deploy Keycloak Service in kubernetes(minikube)

1. Run init 
```sh
terraform init
``` 
2. Run plan
```sh
terraform plan
``` 
3. Run apply
```sh
terraform apply 
```

postgres DB is used to store the keycloak realted configuration.

To check if the keycloak is pointing to a postgres database, run the following command:

1. Check for pods in the namespace
```sh
kubectl get pods -n wdi
```
2. Get inside the postgres pod 
```sh
kubectl exec -it <pod-name>  -n <namespace>  -- bin/bash 
```
3. Connect to the postgres user 
```sh
psql -U postgres;
```
4. Connect to the keycloak database
```sh
\c keycloak;
```
5. Get the list of keycloak table
```sh
\dt;
```

