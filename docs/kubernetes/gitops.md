---
icon: lucide/git-pull-request-arrow
---

# GitOps

GitOps is the practice of using Git as the single source of truth for declarative infrastructure. We use [Argo CD](https://argoproj.github.io/cd/) to continuously reconcile the cluster to match the desired state in our [infrastructure repository](https://github.com/axolotlcloud/infrastructure). If the current state of the cluster drifts from the desired state declared in Git, Argo CD automatically synchronizes the cluster. This also means that every change to the cluster is a commit, which gives us auditable history and easier rollbacks.

## Argo CD

We run the high availability install of Argo CD and bootstrap it with a single [`ApplicationSet`](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/). It scans the project directories in our repository and creates an Argo CD application for each directory it finds, with automatic synchronization enabled. To deploy something new to the cluster, we simply commit a new directory.

## Manifests

All of our manifests are composed with [Kustomize](https://kustomize.io/). Any upstream Helm charts are rendered inline with Kustomize, so chart versions and values are stored in Git along with the rest of our resources. We also built a custom Kustomize generator that is a containerized [KRM function](https://kubectl.docs.kubernetes.io/guides/extending_kustomize/containerized_krm_functions/) which renders [Jsonnet](https://jsonnet.org/) configuration. We use it with [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus) to generate our monitoring stack[^1].

## Secrets

We encrypt secrets with [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) so that they can be safely committed to a public repository. A `SealedSecret` can only be decrypted by the controller running in our cluster. For secrets that are built from values already present in the cluster, we use [External Secrets](https://external-secrets.io/) to compose them declaratively. We also manage some resources outside of the cluster with [Crossplane](https://www.crossplane.io/), such as the Microsoft Entra ID app registrations for SSO with OAuth2/OIDC.

## Automated Image Updates

[Argo CD Image Updater](https://argocd-image-updater.readthedocs.io/) watches our container registries for new container images and commits tag/digest updates back to the repository. This way, the repository remains the source of truth even for automated changes.

[^1]: Learn more about our monitoring setup on the [observability page](./observability.md).
