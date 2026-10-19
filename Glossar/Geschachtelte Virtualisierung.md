---
aliases: [Nested Virtualization, Nested Hyper-V, Verschachtelte Virtualisierung]
tags: [glossar, glossar/virtualisierung, az-802]
en: "Nested Virtualization"
de: "Geschachtelte Virtualisierung"
bereich: Virtualisierung
---

# Geschachtelte Virtualisierung

Hyper-V (oder Container mit Hyper-V-Isolierung) **innerhalb** einer VM.

- VM muss aus sein; Prozessor-Erweiterungen freigeben + MAC-Spoofing für Netzwerk der inneren VMs
- Ideal fürs Lab: Cluster, Livemigration, Replikat ohne zweite Hardware

Maschine: **Hyper-V-Host (physisch)**
```powershell
Set-VMProcessor -VMName EXA-HV01 -ExposeVirtualizationExtensions $true
Set-VMNetworkAdapter -VMName EXA-HV01 -MacAddressSpoofing On
```

**Siehe auch:** [[Hyper-V]] · [[Hyper-V Livemigration]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
