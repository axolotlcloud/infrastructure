---
icon: lucide/scroll-text
---

# Overview

Our hyperconverged, highly available Kubernetes cluster runs on 3 bare-metal machines with Talos Linux. All 3 nodes are a part of the Kubernetes control plane, the etcd cluster, and the Ceph cluster, and also allow scheduling as this is a fairly small deployment.

![Three-node HA Kubernetes cluster](../assets/kubernetes-ha-3node.svg){ width="1000" }

## Key characteristics

- **Hyperconverged:** compute and storage share the same 3 nodes.
- **Immutable OS:** Talos Linux is API-driven and declarative, eliminating configuration drift.
- **Highly available control plane:** 3 control plane nodes + 3-member etcd cluster.
- **Distributed storage:** Ceph spans all 3 nodes to provide block, file, and object storage.
- **GitOps-managed:** cluster state is managed declaratively from git and continuously reconciled.

### Operating System

[Talos Linux](https://www.talos.dev/) is a secure, immutable, and minimal operating system for Kubernetes that removes configuration drift with infrastructure as code. All configuration for the OS is declarative and submitted to Talos' API. There is no SSH, no package manager, no shell; it is extremely minimal. This makes it the perfect OS to purely run Kubernetes.

## Core components

- **Networking (CNI):** [Cilium](https://cilium.io)
- **Networking (Service Mesh):** [Istio](https://istio.io)
- **Certificates:** [cert-manager](https://cert-manager.io/)
- **Storage:** [Rook Ceph](https://rook.io/)
- **Secrets Management:** [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)
- **Observability:** [Grafana](https://grafana.com/grafana/), [Hubble](https://github.com/cilium/hubble), [Kiali](https://kiali.io/), [Prometheus](https://prometheus.io/), [Loki](https://grafana.com/oss/loki/), [Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/), and more
- **Infrastructure as Code:** [Crossplane](https://www.crossplane.io)
- **GitOps:** [Argo CD](https://argoproj.github.io/cd/)
- **Policy:** [Kyverno](https://kyverno.io/)
- **Databases:** [CloudNativePG](https://cloudnative-pg.io/) (PostgreSQL), [Redis Operator](https://redis-operator.opstree.dev/)
