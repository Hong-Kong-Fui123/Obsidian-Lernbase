---
aliases:
  - VM-Export
  - Export-VM
  - Hyper-V Export
tags:
  - glossar
  - glossar/virtualisierung
en: VM Export
de: VM-Export
bereich: Virtualisierung
---

**VM-Export** = *VM Export*
**Deutsch:** VM-Export

## Kurz
Kopiert eine VM (Konfiguration, virtuelle Festplatten, Checkpoints) in einen portablen Ordner.

## Details
- Cmdlet `Export-VM`, GUI: Hyper-V Manager → *Export…*
- Live-Export möglich, sauberer: VM vorher herunterfahren
- Kein Ersatz für eine Backup-Strategie

## Beispiel
Maschine: **Quell-Hyper-V-Host**
```powershell
Stop-VM -Name EXA-SRV02
Export-VM -Name EXA-SRV02 -Path 'C:\export1'
```

## Prüfungsfrage
Welche drei Unterordner enthält ein Export?

> [!success]- Lösung
> `Virtual Machines`, `Virtual Hard Disks`, `Snapshots`.

## Siehe auch
[[VM-Import]] · [[VMCX]] · [[VHDX]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
