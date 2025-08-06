# Talos

To generate configuration for each node, run the following commands.

```sh
talosctl gen config axolotl https://k8s.lan.axolotl.cloud:6443 --talos-version=v1.10.5 --with-secrets secrets.yaml --config-patch @controlplane-patch-x.yaml --config-patch @controlplane-patch-0.yaml

talosctl gen config axolotl https://k8s.lan.axolotl.cloud:6443 --talos-version=v1.10.5 --with-secrets secrets.yaml --config-patch @controlplane-patch-x.yaml --config-patch @controlplane-patch-1.yaml

talosctl gen config axolotl https://k8s.lan.axolotl.cloud:6443 --talos-version=v1.10.5 --with-secrets secrets.yaml --config-patch @controlplane-patch-x.yaml --config-patch @controlplane-patch-2.yaml
```
