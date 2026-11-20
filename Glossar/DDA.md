---
aliases: [Gerätezuweisung, Passthrough]
tags: [glossar, glossar/virtualisierung, az-802]
en: Discrete Device Assignment
de: Diskrete Gerätezuweisung
bereich: virtualisierung
---
# DDA

**Definition:** Ganzes PCIe-Gerät (GPU, NVMe) exklusiv an eine VM durchreichen.

**Prüfungsfalle:** Keine Live-Migration, kein dyn. RAM; Alternative für GPUs: GPU-Partitionierung.

**Prüfen:** `Get-VMAssignableDevice`

↑ [[AZ-802 03 Virtuelle Computer]] · [[00_Glossar-AZ-802-Index]]
