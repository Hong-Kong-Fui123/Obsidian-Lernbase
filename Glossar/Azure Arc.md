---
aliases: [Arc, Azure Arc-fähige Server, Arc-enabled Servers, azcmagent]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure Arc-enabled servers"
de: "Azure Arc-fähige Server"
bereich: Virtualisierung-Cloud
---

# Azure Arc

Bindet Server **außerhalb** von Azure (lokal, andere Clouds) als Azure-Ressource ein – für Richtlinien, Updates, Überwachung und Sicherheit aus Azure.

- Connected Machine Agent (`azcmagent`), nur **ausgehend HTTPS 443**
- VM-Erweiterungen (z. B. [[AMA]], Defender, Custom Script) und Azure Policy/Computerkonfiguration
- Dienste: [[Azure Update Manager]], [[Azure Monitor]], [[Defender for Servers]], [[Hotpatch]], ESU

Maschine: **EXA-SRV01**
```powershell
azcmagent connect --resource-group rg-az802-lab --tenant-id <ID> --location germanywestcentral --subscription-id <ID>
azcmagent show
```

**Siehe auch:** [[Windows Admin Center]] · [[Azure Update Manager]]
**Thema:** [[AZ-802 2 Hybride Verwaltung]] · [[AZ-802 Übersicht]]
