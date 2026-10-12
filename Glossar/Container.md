---
aliases:
  - Container
  - Docker-Container
tags:
  - glossar
  - glossar/virtualisierung
en: Container
de: Container (isolierte Anwendungsumgebung)
bereich: Virtualisierung
---

**Container** = *Container*
**Deutsch:** Container (isolierte Anwendungsumgebung)

## Kurz
Laufende, isolierte Instanz eines [[Image|Images]]. Ein Container teilt sich den Kernel mit dem Host und enthält nur Anwendung und Abhängigkeiten.

## Details
- Isolation über [[Namespace|Namespaces]], Ressourcengrenzen über [[cgroups]]
- Start in Sekunden, Größe in MB statt GB
- Beschreibbare Schicht geht bei `docker rm` verloren → Daten in [[Volume|Volumes]]
- Zustände: created → running → exited

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker run -d --name web01 -p 8080:80 nginx:1.27-alpine
docker ps
docker stop web01 && docker rm web01
```

## Prüfungsfrage
Was unterscheidet einen Container von einer VM?

> [!success]- Lösung
> Container nutzt den Host-Kernel (kein eigenes OS), VM virtualisiert Hardware mit eigenem Gast-OS.

## Siehe auch
[[Image]] · [[Docker]] · [[Volume]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
