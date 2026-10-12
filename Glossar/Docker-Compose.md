---
aliases:
  - Docker-Compose
  - Compose
  - docker compose
  - compose.yaml
tags:
  - glossar
  - glossar/virtualisierung
en: Docker Compose
de: Mehrcontainer-Verwaltung
bereich: Virtualisierung
---

**Docker-Compose** = *Docker Compose*
**Deutsch:** Mehrcontainer-Verwaltung

## Kurz
Werkzeug, das mehrere Container, Netzwerke und Volumes in einer YAML-Datei (`compose.yaml`) beschreibt und gemeinsam startet.

## Details
- Compose v2: `docker compose` (ohne Bindestrich)
- Variablen aus `.env`
- Infrastruktur als Code: Datei gehört ins Git

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker compose config
docker compose up -d
docker compose ps
docker compose down
```

## Prüfungsfrage
Was löscht `docker compose down -v` zusätzlich?

> [!success]- Lösung
> Die Volumes – also auch die Daten.

## Siehe auch
[[Container]] · [[Volume]] · [[Restart-Policy]] · [[Healthcheck]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
