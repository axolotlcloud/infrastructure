<div align="center">
  <a align="center" href="https://axolotl.cloud">
    <picture>
      <img src="https://github.com/axolotlcloud.png" align="center" alt="Axolotl Cloud" height="320" />
    </picture>
  </a>
  <hr />
  <p align="center">All of your axolotls in one place.</p>
</div>

| Service       | URL                               | Access              |
|---------------|-----------------------------------|---------------------|
| Argo CD       | https://argocd.axolotl.cloud      | Internal            |
| Audrey Asked  | https://audreyasked.com           | Public              |
| Axolotl Cloud | https://axolotl.cloud             | Public              |
| Ceph          | https://ceph.axolotl.cloud        | Internal            |
| Dennis Pham   | https://dennispham.me             | Public              |
| Grafana       | https://grafana.axolotl.cloud     | Internal            |
| Hubble        | https://hubble.axolotl.cloud      | Public              |
| Immich        | https://photos.axolotl.cloud      | Public and internal |
| Jellyfin      | https://watch.axolotl.cloud       | Public and internal |
| Jellyseerr    | https://request.axolotl.cloud     | Public and internal |
| OpenCloud     | https://office.axolotl.cloud      | Public and internal |
| Prowlarr      | https://prowlarr.axolotl.cloud    | Internal            |
| qBittorrent   | https://qbittorrent.axolotl.cloud | Internal            |
| Radarr        | https://radarr.axolotl.cloud      | Internal            |
| S3            | https://s3.axolotl.cloud          | Public and internal |
| Sonarr        | https://sonarr.axolotl.cloud      | Internal            |
| Sure          | https://finance.axolotl.cloud     | Public and internal |
| Whoami        | https://whoami.axolotl.cloud      | Public and internal |
| Yonder        | https://yonder.sh                 | Public              |

## Access

There are two ingress gateways:

- The internal ingress gateway receives traffic from the LAN and from devices connected to the VPN through Cloudflare One.
- The public ingress gateway receives public traffic that is proxied through Cloudflare. Traffic between Cloudflare and the gateway is secured with mTLS.

Services can be configured to be accessed through the internal gateway, public gateway, or both. The same hostname can be used when routes are configured on both gateways, as clients are automatically routed to the correct gateway through split-horizon DNS.

When a device is connected directly to our internal network or through our VPN, our internal DNS service returns the IP of the internal gateway for a given service if internal access is enabled for it.
