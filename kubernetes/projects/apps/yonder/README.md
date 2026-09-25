# Yonder

[Yonder](https://yonder.sh), a group trip planner. Source: [yonder-sh/yonder](https://github.com/yonder-sh/yonder).

## What's deployed

| Component | What | Notes |
|---|---|---|
| `web/` | Deployment `web` (`ghcr.io/yonder-sh/yonder`) | initContainers run the migrations and set up the media bucket. `GET /api/health` |
| `collab/` | Deployment `collab` (`ghcr.io/yonder-sh/yonder-collab`) | Realtime server (Hocuspocus), served at `/collab` |
| `worker/` | Deployment `worker` (same image as collab) | Background jobs (thumbnails, video posters, PDFs) |
| Postgres | CNPG `postgres` | Nightly base backups + WAL archiving to `yonder-backups` |
| Redis | OT `redis` | Password in `redis-secret` |
| Media | Bucket `yonder-media` on the public store | Private objects, reached with presigned URLs via `https://s3.axolotl.cloud` |

`https://yonder.sh/collab` goes to `collab` and everything else to `web`. The gateway's `yonder-sh` listeners live in `core/istio`.

## Operations

Raise one person's upload quota (the default is `STORAGE_QUOTA_DEFAULT_GB` in `configmap.yaml`):

```bash
kubectl -n yonder exec deploy/web -- node .output/scripts/set-quota.mjs <email> <GB>
```

Check the backups (point-in-time recovery covers the last 14 days):

```bash
kubectl -n yonder get backup
kubectl -n yonder get cluster postgres -o jsonpath='{.status.firstRecoverabilityPoint}{"\n"}{.status.lastSuccessfulBackup}{"\n"}'
```

Media isn't in these backups; the bucket keeps 14 days of old versions.

### Restoring Postgres

CNPG restores by creating a new cluster from the backups, archiving to a new folder (`serverName`).

1. Add `yonder` to `autoSyncExclusions` in `root/bootstrap/applicationset.yaml` and push, then stop the app: `kubectl -n yonder scale deploy/web deploy/collab deploy/worker --replicas=0`.
2. In `postgres.yaml`, add the recovery source and a new archive folder, then push:
   ```yaml
   spec:
     bootstrap:
       recovery:
         source: postgres-backup
         database: app
         owner: app
         # recoveryTarget:
         #   targetTime: "2027-10-05 08:00:00+00"   # omit to replay to the end
     externalClusters:
     - name: postgres-backup
       barmanObjectStore:
         serverName: postgres        # the folder to restore from
         destinationPath: s3://yonder-backups/
         endpointURL: http://rook-ceph-rgw-axolotl-private-object-store.rook-ceph.svc:80
         s3Credentials:
           accessKeyId:
             name: rook-ceph-object-user-axolotl-private-object-store-yonder-backups
             key: AccessKey
           secretAccessKey:
             name: rook-ceph-object-user-axolotl-private-object-store-yonder-backups
             key: SecretKey
     backup:
       barmanObjectStore:
         serverName: postgres-2      # the new folder to archive to (keep the rest of the block)
   ```
3. `kubectl -n yonder delete cluster postgres`, sync in Argo CD, and wait until the cluster is healthy.
4. Sync again (the Deployments come back), remove `yonder` from `autoSyncExclusions`, push, and take a fresh backup: `kubectl cnpg backup postgres -n yonder`.

Next time, restore from `postgres-2` and archive to `postgres-3`.
