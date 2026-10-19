---
aliases: [DHCP Failover, DHCP-Ausfallsicherheit]
tags: [glossar, glossar/netzwerk, az-802]
en: "DHCP Failover"
de: "DHCP-Failover"
bereich: Netzwerk
---

# DHCP-Failover

Zwei DHCP-Server teilen sich einen IPv4-Bereich und gleichen Leases ab.

- **Lastenausgleich** (Standard 50:50) oder **Heißer Standby** (Standard 5 % Reserve)
- Max. 2 Server je Beziehung, nur IPv4; MCLT begrenzt eigenmächtige Lease-Verlängerung

Maschine: **EXA-DC01**
```powershell
Add-DhcpServerv4Failover -Name DC01-DC02 -PartnerServer EXA-DC02 -ScopeId 192.168.1.0 -LoadBalancePercent 50 -SharedSecret 'Geheim!'
```

**Siehe auch:** [[DHCP]] · [[DHCP-Server]]
**Thema:** [[AZ-802 4 Netzwerk DNS DHCP]] · [[AZ-802 Übersicht]]
