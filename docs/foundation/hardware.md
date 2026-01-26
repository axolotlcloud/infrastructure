---
icon: lucide/server
---

# Hardware

## Overview

Axolotl Cloud has a 25U rack with a network switch, a router, 3 server nodes, a PDU, and a UPS.

The network switch is a [Mikrotik CRS309-1G-8S+IN](https://mikrotik.com/product/crs309_1g_8s_in), which has eight 10Gb SFP+ ports and one 1Gb Ethernet port.

The router is a [Mikrotik RB5009UG+S+IN](https://mikrotik.com/product/rb5009ug_s_in), which has one 10Gb SFP+ port, one 2.5Gb Ethernet port, and seven 1Gb Ethernet ports. It essentially acts as a router-on-a-stick. Learn more [here](./networking.md).

Each of the 3 server nodes contains the following:

- AMD Ryzen 9 5900XT (16c, 32t; 4.8GHz max boost)
- NVIDIA GeForce GT 1030
- 64GB of DDR4 ECC RAM
- 500GB boot SSD
- 3x 8TB HDDs
- [Sipeed NanoKVM (PCIe)](https://wiki.sipeed.com/hardware/en/kvm/NanoKVM_PCIe/introduction.html)

This makes for a total of **96 vCPUs**, **192GB of memory**, and **72TB of storage**.

The PDU is a [CyberPower CPS1215RMS](https://www.cyberpowersystems.com/product/surge/rackbar/cps1215rms/) and the UPS is a [CyberPower CP1500PFCRM2U](https://www.cyberpowersystems.com/product/ups/pfc-sinewave/cp1500pfcrm2u/), which can handle up to 1500VA/1000W.

## Server Rack

<figure markdown="span">
    ![Server Rack](../assets/rack.svg){ width="420" }
</figure>
