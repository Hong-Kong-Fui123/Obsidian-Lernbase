---
aliases: [Speicher-QoS, Storage Quality of Service]
tags: [glossar, glossar/hardware-storage, az-802]
en: "Storage Quality of Service"
de: "Speicher-Dienstgüte"
bereich: Hardware-Storage
---

# Storage QoS

Begrenzt oder garantiert IOPS für VHDX-Dateien auf **CSV/Scale-Out File Server**.

- Richtlinien *Dediziert* (Wert je VHD) oder *Aggregiert* (Wert gemeinsam)
- Minimum- und Maximum-IOPS

Maschine: **Clusterknoten**
```powershell
New-StorageQosPolicy -Name Gold -PolicyType Dedicated -MinimumIops 500 -MaximumIops 2000
Get-StorageQosFlow
```

**Siehe auch:** [[CSV]] · [[SoFS]] · [[VHDX]]
**Thema:** [[AZ-802 5 Speicher und Dateidienste]] · [[AZ-802 Übersicht]]
