---
aliases:
  - Docker-Desktop
  - Docker Desktop
tags:
  - glossar
  - glossar/virtualisierung
en: Docker Desktop
de: Docker mit grafischer Oberfläche
bereich: Virtualisierung
---

**Docker-Desktop** = *Docker Desktop*
**Deutsch:** Docker mit grafischer Oberfläche

## Kurz
Anwendung mit GUI für Windows, macOS und Linux-Desktops. Enthält Engine, CLI, Compose und optional Kubernetes.

## Details
- Linux-Container unter Windows über [[WSL2]]
- Läuft **nicht** auf Windows Server
- Kostenlos privat/Lernen; Firmen ab 250 Mitarbeitenden oder 10 Mio. USD Umsatz kostenpflichtig

## Beispiel
Maschine: **Windows-11-PC**
```powershell
wsl --install
winget install -e --id Docker.DockerDesktop
docker version
```

## Prüfungsfrage
Kann Docker Desktop auf Windows Server 2025 installiert werden?

> [!success]- Lösung
> Nein, dort Docker CE (nur Windows-Container) oder eine Linux-VM nutzen.

## Siehe auch
[[WSL2]] · [[Docker-Engine]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
