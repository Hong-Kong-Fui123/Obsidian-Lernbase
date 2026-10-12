---
aliases:
  - WSL2
  - WSL
  - Windows Subsystem for Linux
tags:
  - glossar
  - glossar/virtualisierung
en: Windows Subsystem for Linux 2
de: Windows-Subsystem für Linux, Version 2
bereich: Virtualisierung
---

**WSL2** = *Windows Subsystem for Linux 2*
**Deutsch:** Windows-Subsystem für Linux, Version 2

## Kurz
Echter Linux-Kernel in einer leichten, Hyper-V-basierten VM unter Windows 10/11.

## Details
- Basis für Linux-Container in [[Docker-Desktop]]
- Linux-Distributionen (z. B. Ubuntu) direkt unter Windows
- Zugriff auf Linux-Dateien: `\\wsl$\`

## Beispiel
Maschine: **Windows-11-PC**
```powershell
wsl --install
wsl --status
wsl -l -v   # Distributionen und Version
```

## Prüfungsfrage
Warum braucht Docker Desktop für Linux-Container WSL2?

> [!success]- Lösung
> Linux-Container benötigen einen Linux-Kernel, den Windows nicht hat.

## Siehe auch
[[Docker-Desktop]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
