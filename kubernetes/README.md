# Kubernetes p8e Environment

This directory contains Kubernetes resources and Kustomize overlays intended to be used as a reference for spinning up a p8e environment in a Kubernetes cluster.

## Running Locally

Docker Desktop comes with a built-in Kubernetes cluster for running k8s resources locally. In order to use this you must first enable Kubernetes on Docker Desktop.

The `local` directory contains Kustomize overlays that add in elasticsearch and postgres pods. A production environment could theoretically use a similar setup for these resources, but often it makes more sense to use a cloud postgres/elasticsearch instance.

To spin up the local environment, run the command `kubectl apply -k local` which will apply the resources/overlays to your local k8s. **Note: it is important that you ensure you are connected to your local k8s context utilizing kubectx**

The `dev` directory is intended for developers working on p8e to spin up all local resources except for `p8e` and `p8e-webservice` as they will be running these externally for development.

**Note: currently, the local setup does not run the provenance validator nodes as the docker-compose example does, hopefully this will change soon and everything will work like :magic:**

To run the provenance network for local development, navigate to the `docker-compose` directory at the root of this repository and run `./bin/one-time-setup-k8s.sh` (to set up the network) and then `./bin/start-k8s` (to run the local nodes). Once that is complete, you can run the local k8s setup from within the `kubernetes` directory (`kubectl apply -k local`).