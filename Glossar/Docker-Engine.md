---
aliases:
  - Docker-Engine
  - Engine
  - Docker CE
tags:
  - glossar
  - glossar/virtualisierung
en: Docker Engine
de: Docker-Laufzeitumgebung
bereich: Virtualisierung
---

**Docker-Engine** = *Docker Engine*
**Deutsch:** Docker-Laufzeitumgebung

## Kurz
Gesamtpaket aus Docker-[[CLI]], [[Docker-Daemon]] und Container-Laufzeit ([[Containerd]], runc).

## Details
- Client-Server-Prinzip: CLI spricht über eine [[API]] mit dem Daemon
- Docker CE = kostenlose Community Edition
- Läuft nativ unter Linux, als Docker CE auf Windows Server

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker version   # Abschnitt Client und Server
docker info
```

## Prüfungsfrage
Was bedeutet es, wenn `docker version` nur den Abschnitt Client zeigt?

> [!success]- Lösung
> Die CLI erreicht den Daemon nicht – Dienst gestoppt oder keine Berechtigung.

## Siehe auch
[[Docker-Daemon]] · [[Containerd]] · [[CLI]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
