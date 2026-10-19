---
aliases: [Discrete Device Assignment, Diskrete Gerätezuweisung]
tags: [glossar, glossar/virtualisierung, az-802]
en: "Discrete Device Assignment"
de: "Diskrete Gerätezuweisung"
bereich: Virtualisierung
---

# DDA

Reicht ein **ganzes** PCIe-Gerät (GPU, NVMe) exklusiv an eine VM durch.

- Gerät am Host deaktivieren → `Dismount-VMHostAssignableDevice` → `Add-VMAssignableDevice`
- VM mit DDA: kein Speichern/Livemigration wie üblich

**Siehe auch:** [[GPU-P]] · [[Hyper-V]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
