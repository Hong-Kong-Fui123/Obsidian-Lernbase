---
aliases:
  - Checkpoint
  - Snapshot
  - Prüfpunkt
tags:
  - glossar
  - glossar/virtualisierung
en: Checkpoint
de: Prüfpunkt (Momentaufnahme)
bereich: Virtualisierung
---

**Checkpoint** = *Checkpoint*
**Deutsch:** Prüfpunkt (Momentaufnahme)

## Kurz
Zeitpunkt-Zustand einer VM, früher „Snapshot“ genannt.

## Details
- Standard-Checkpoint: inkl. RAM-Zustand
- Produktions-Checkpoint: VSS-konsistent, ohne RAM (Standard)
- Kein Backup-Ersatz; bei DCs nur Produktions-Checkpoints

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Checkpoint-VM -Name EXA-SRV02 -SnapshotName 'vor-Update'
Get-VMSnapshot -VMName EXA-SRV02
Restore-VMSnapshot -VMName EXA-SRV02 -Name 'vor-Update' -Confirm:$false
```

## Prüfungsfrage
Warum ist ein Checkpoint kein Backup?

> [!success]- Lösung
> Er liegt auf demselben Speicher wie die VM und hängt von der Eltern-VHDX ab.

## Siehe auch
[[AVHDX]] · [[VM-Export]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]

**AZ-802:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
