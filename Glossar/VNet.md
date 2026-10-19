---
aliases: [Virtual Network, Virtuelles Netzwerk, Azure VNet]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure Virtual Network"
de: "Virtuelles Netzwerk in Azure"
bereich: Virtualisierung-Cloud
---

# VNet

Privates Netz in Azure mit eigenem Adressraum und Subnetzen.

- Verbindung lokal ↔ Azure: VPN-Gateway oder ExpressRoute; VNet ↔ VNet: Peering
- Adressräume dürfen sich mit dem LAN nicht überschneiden
- DNS-Einstellung des VNets bestimmt, welche DNS-Server die VMs bekommen (für AD: die DCs)

**Siehe auch:** [[NSG]] · [[Azure DNS Private Resolver]]
**Thema:** [[Azure-Grundlagen für Windows-Admins]] · [[AZ-802 Übersicht]]
