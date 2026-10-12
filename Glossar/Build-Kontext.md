---
aliases:
  - Build-Kontext
  - Build Context
tags:
  - glossar
  - glossar/virtualisierung
en: Build Context
de: Build-Kontext (Bauverzeichnis)
bereich: Virtualisierung
---

**Build-Kontext** = *Build Context*
**Deutsch:** Build-Kontext (Bauverzeichnis)

## Kurz
Verzeichnis, das bei `docker build` an den Docker-Daemon übertragen wird, meist der aktuelle Ordner `.`.

## Details
- Nur Dateien im Kontext stehen für `COPY`/`ADD` zur Verfügung
- Großer Kontext = langsamer Build
- `.dockerignore` verhindert, dass `.git`, Logs oder `.env` ins Image gelangen

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
cd ~/projekte/meinweb
docker build -t meinweb:1.0 .   # Punkt = Build-Kontext
```

## Prüfungsfrage
Warum kann `COPY ../config.txt /app/` scheitern?

> [!success]- Lösung
> Die Datei liegt außerhalb des Build-Kontexts; Docker darf nur auf Dateien im Kontext zugreifen.

## Siehe auch
[[Dockerfile]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
