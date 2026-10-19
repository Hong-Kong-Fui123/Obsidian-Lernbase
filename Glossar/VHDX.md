---
aliases:
  - VHDX
  - vhdx
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Hard Disk v2
de: Virtuelle Festplatte (Version 2)
bereich: Virtualisierung
---

**VHDX** = *Virtual Hard Disk v2*
**Deutsch:** Virtuelle Festplatte (Version 2)

## Kurz
Format für virtuelle Festplatten in Hyper-V, bis 64 TB, ausfallsicherer als das alte VHD.

## Details
- Typen: feste Größe · dynamisch erweiterbar · differenzierend
- Größe prüfen: `Get-VHD`
- Verkleinern: `Optimize-VHD` (VM aus)

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-VHD -Path 'D:\Hyper-V\EXA-SRV02\EXA-SRV02.vhdx' | Select VhdType, Size, FileSize
```

## Prüfungsfrage
Unterschied `Size` und `FileSize` bei `Get-VHD`?

> [!success]- Lösung
> `Size` = maximale Größe, `FileSize` = tatsächlich belegter Platz auf dem Host.

## Siehe auch
[[AVHDX]] · [[VM-Export]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]

**AZ-802:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
