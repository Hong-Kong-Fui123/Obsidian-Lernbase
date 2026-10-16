---
aliases:
  - RDMA
  - Remote Direct Memory Access
tags:
  - glossar
  - glossar/hardware-storage
en: Remote Direct Memory Access
de: Direkter Speicherzugriff über das Netzwerk
bereich: Hardware-Storage
---

**RDMA** = *Remote Direct Memory Access*
**Deutsch:** Direkter Speicherzugriff über das Netzwerk

## Kurz
Netzwerkkarten schreiben Daten direkt in den RAM des Zielrechners – an der CPU vorbei. Sehr hoher Durchsatz, sehr niedrige Latenz.

## Details
- Varianten: iWARP, RoCE (braucht DCB-fähige Switches), InfiniBand
- Grundlage für [[SMB Direct]] (Livemigration, [[SoFS]], S2D)
- Prüfen: `Get-NetAdapterRdma`

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-NetAdapterRdma | Format-Table Name, Enabled
```

## Prüfungsfrage
Welchen Vorteil bringt RDMA bei der Livemigration?

> [!success]- Lösung
> RAM-Kopie mit voller Netzgeschwindigkeit bei kaum CPU-Last.

## Siehe auch
[[SMB Direct]] · [[SMB Multichannel]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
