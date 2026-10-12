---
aliases:
  - Prozess-Isolation
  - Process Isolation
tags:
  - glossar
  - glossar/virtualisierung
en: Process Isolation
de: Prozess-Isolation
bereich: Virtualisierung
---

**Prozess-Isolation** = *Process Isolation*
**Deutsch:** Prozess-Isolation

## Kurz
Modus für Windows-Container: Der Container teilt sich den Kernel des Hosts.

## Details
- Schnell, wenig Ressourcen
- Build von Image und Host müssen übereinstimmen
- Parameter: `--isolation=process`

## Beispiel
Maschine: **EXA-DOCKER02**
```powershell
docker run --rm --isolation=process mcr.microsoft.com/windows/nanoserver:ltsc2025 cmd /c ver
```

## Prüfungsfrage
Was passiert bei unterschiedlicher Windows-Version in Prozess-Isolation?

> [!success]- Lösung
> Der Start scheitert; Lösung: passendes Image oder Hyper-V-Isolation.

## Siehe auch
[[Hyper-V-Isolation]] · [[Windows-Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
