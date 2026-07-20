---
icon: lucide/telescope
---

# Observability

## Metrics

We collect cluster metrics with [Prometheus](https://prometheus.io/), deployed with the [Prometheus Operator](https://prometheus-operator.dev/). Alongside it, we run [Alertmanager](https://github.com/prometheus/alertmanager), [Node exporter](https://github.com/prometheus/node_exporter), [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics), and more. Components expose their metrics to Prometheus with `ServiceMonitor` and `PodMonitor` resources, including the Envoy proxies of our Istio ingress gateways and waypoints.

## Dashboards & Alerting

[Grafana](https://grafana.com/grafana/) allows us to query, visualize, and alert on our metrics and logs. We deploy it with the [Grafana Operator](https://grafana.github.io/grafana-operator/), so our dashboards, datasources, and alerting configuration are all custom resources stored in git. Grafana is backed by a [CloudNativePG](https://cloudnative-pg.io/) PostgreSQL cluster, and alerts are sent to Discord.

## Logs

We collect logs with [Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/), which collects container logs and Kubernetes cluster events and pushes them to [Loki](https://grafana.com/oss/loki/). Loki stores its data in S3-compatible object storage that Ceph provides[^1].

## Network & Mesh

[Hubble](https://github.com/cilium/hubble) provides visibility into network flows, and [Kiali](https://kiali.io/) visualizes traffic in the service mesh. Learn more about both on the [networking page](./networking.md).

## Future Plans

In the future, we plan to expand our alerting coverage and look into distributed tracing with [Tempo](https://grafana.com/oss/tempo/).

[^1]: Learn more about our Ceph cluster on the [storage page](./storage.md).
