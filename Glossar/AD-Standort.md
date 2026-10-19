---
aliases: [AD Site, Standort, Active Directory-Standort, Sites]
tags: [glossar, glossar/windows-server, az-802]
en: "Active Directory Site"
de: "Active-Directory-Standort"
bereich: Windows-Server
---

# AD-Standort

Gruppe gut verbundener IP-Subnetze. Steuert, welchen DC ein Client nutzt und wie repliziert wird.

- Standortverknüpfung: Kosten (Standard 100) und Intervall (Standard 180 Min.)
- Replikation zwischen Standorten über Brückenkopfserver, Topologie vom KCC/ISTG
- Azure-VNet = eigener Standort mit eigenem Subnetz

Maschine: **EXA-DC01**
```powershell
New-ADReplicationSite -Name Azure-GWC
New-ADReplicationSubnet -Name 10.10.0.0/16 -Site Azure-GWC
```

**Siehe auch:** [[repadmin]] · [[FSMO]] · [[DC]]
**Thema:** [[AZ-802 1 AD DS]] · [[AZ-802 Übersicht]]
