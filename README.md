# Cloud SQL Proxy Test

## Auth

* `gcloud auth application-default login`
* `gcloud config set project [Your Project ID]`

## Enable services

```bash
./enable_services.sh
```

## Terraform

* Install [tfenv](https://github.com/tfutils/tfenv)
* Run `tfenv install` to download terraform with version specified in `.terraform-version` file
* `terraform init`
* `terraform apply` and enter `[Your Project ID]` or `terraform apply -var-file=your.tfvars` something like this:

```your.tfvars
project = "[Your Project ID]"
```

## Dockernize Flask container

```bash
cd flask-api
docker build -t gcr.io/[Your Project ID]/flask-api:latest .

gcloud auth configure-docker
docker push gcr.io/[Your Project ID]/flask-api:latest
```

## GKE

```bash
gcloud container clusters get-credentials my-gke-cluster
```

Create a secret from credential file (which is a credential json file for a service account you must create)

```bash
cd k8s
kubectl create secret generic cloudsql-instance-credentials --from-file=./credentials.json

```

Deploy k8s

```bash
kubectl apply -f k8s.yaml
```
