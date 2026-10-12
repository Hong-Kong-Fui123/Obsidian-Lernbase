---
aliases:
  - Hyper-V-Isolation
  - Hyper-V Isolation
tags:
  - glossar
  - glossar/virtualisierung
en: Hyper-V Isolation
de: Hyper-V-Isolation
bereich: Virtualisierung
---

**Hyper-V-Isolation** = *Hyper-V Isolation*
**Deutsch:** Hyper-V-Isolation

## Kurz
Modus für Windows-Container: Jeder Container läuft in einer eigenen, schlanken Hyper-V-VM mit eigenem Kernel.

## Details
- Stärkere Isolation (mandantenfähig)
- Ältere Image-Versionen auf neuerem Host möglich
- Braucht Virtualisierung; in einer VM verschachtelte Virtualisierung

## Beispiel
Maschine: **Hyper-V-Host + EXA-DOCKER02**
```powershell
# Hyper-V-Host (VM aus):
Set-VMProcessor -VMName EXA-DOCKER02 -ExposeVirtualizationExtensions $true
# EXA-DOCKER02:
docker run --rm --isolation=hyperv mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd /c ver
```

## Prüfungsfrage
Welche Einstellung braucht EXA-DOCKER02 für Hyper-V-Isolation?

> [!success]- Lösung
> Verschachtelte Virtualisierung (`ExposeVirtualizationExtensions`) auf dem Hyper-V-Host.

## Siehe auch
[[Prozess-Isolation]] · [[Windows-Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
