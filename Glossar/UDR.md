---
aliases: [User Defined Route, Benutzerdefinierte Route, Routentabelle]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "User-defined route"
de: "Benutzerdefinierte Route"
bereich: Virtualisierung-Cloud
---

# UDR

Eigene Route in einer Azure-Routentabelle, die einem Subnetz zugeordnet wird und Systemrouten überschreibt.

- Nächster Hop: virtuelles Gerät (Firewall-VM), VNet-Gateway, VNet, Internet, None
- Vorrang bei gleichem Präfix: **UDR > BGP > System**
- Firewall-VM braucht **IP-Weiterleitung** an der NIC; Prüfen: Network Watcher „Nächster Hop“

**Siehe auch:** [[VNet]] · [[NSG]]
**Thema:** [[Azure DNS und DHCP hybrid]] · [[AZ-802 4 Netzwerk DNS DHCP]]
