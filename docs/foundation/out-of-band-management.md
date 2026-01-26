---
icon: lucide/cog
---

# Out-of-Band Management

For management of server nodes, each node has a [Sipeed NanoKVM (PCIe)](https://wiki.sipeed.com/hardware/en/kvm/NanoKVM_PCIe/introduction.html) for KVM over IP capabilities. These allow for remote access to stop/start the server, to flash ISOs, to access the BIOS, and of course, to interact with the OS. Even if the OS is frozen or the machine is powered off, we are still able to remotely log in and manage it.

![OOBM](../assets/oobm.png)
