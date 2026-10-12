---
aliases:
  - Windows-Container
  - Windows Container
tags:
  - glossar
  - glossar/virtualisierung
en: Windows Container
de: Windows-Container
bereich: Virtualisierung
---

**Windows-Container** = *Windows Container*
**Deutsch:** Windows-Container

## Kurz
Container mit Windows-Kernel. Laufen nur auf Windows-Hosts (Windows Server, Windows 11).

## Details
- Basis-Images: Server Core, Nano Server von `mcr.microsoft.com`
- Image-Version muss zum Host passen (Server 2025 → `ltsc2025`)
- Keine GUI; AD-Zugriff über gMSA möglich

## Beispiel
Maschine: **EXA-DOCKER02**
```powershell
docker run -d -p 8080:80 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2025
docker info --format '{{.OSType}}'
```

## Prüfungsfrage
Kann ein `nginx`-Linux-Image auf EXA-DOCKER02 laufen?

> [!success]- Lösung
> Nein, die Windows-Engine kann nur Windows-Images ausführen.

## Siehe auch
[[Prozess-Isolation]] · [[Hyper-V-Isolation]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
