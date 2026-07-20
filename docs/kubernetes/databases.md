---
icon: lucide/database
---

# Databases

## PostgreSQL

We provide managed PostgreSQL in-cluster with [CloudNativePG](https://cloudnative-pg.io/). An application declares a Postgres `Cluster` resource alongside its manifests, and the operator provisions the database and generates a secret with the connection details for the application to consume. Storage is provided by our Ceph cluster[^1].

CloudNativePG handles high availability with streaming replication and automated failover, and provides backups with continuous WAL archiving and scheduled backups to object storage. Recovery is declarative, meaning that a new `Cluster` can be bootstrapped from a backup and replay the WAL, optionally up to a point in time.

## Redis

We provide managed Redis with the [Redis Operator](https://redis-operator.opstree.dev/) by OpsTree. Just like PostgreSQL, an application declares a `Redis` resource alongside its manifests, and the operator provisions the instance. It supports standalone, Replication, Sentinel, and Cluster modes.

[^1]: Learn more about our Ceph cluster on the [storage page](./storage.md).
