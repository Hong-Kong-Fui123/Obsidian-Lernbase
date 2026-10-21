---
aliases: [IP Address Management, IP-Adressverwaltung]
tags: [glossar, glossar/windows-server, az-802]
en: "IP Address Management"
de: "IP-Adressverwaltung"
bereich: Windows-Server
---

# IPAM

Windows-Server-Feature zur **zentralen** Verwaltung von DHCP-Servern, DNS-Zonen und IP-Adressräumen.

- Auf Mitgliedsserver (nicht DC), Datenbank WID oder SQL Server
- Server werden per **GPO** eingebunden (`Invoke-IpamGpoProvisioning`)
- Eigene RBAC-Rollen und Zugriffsbereiche; Überwachung der IP-Vergabe

Maschine: **EXA-SRV01**
```powershell
Install-WindowsFeature IPAM -IncludeManagementTools
```

**Siehe auch:** [[DHCP]] · [[DNS]] · [[DHCP-Failover]]
**Thema:** [[Azure DNS und DHCP hybrid]] · [[AZ-802 4 Netzwerk DNS DHCP]]
