---
aliases:
  - Bind-Mount
  - Bind Mount
tags:
  - glossar
  - glossar/virtualisierung
en: Bind Mount
de: Eingebundenes Host-Verzeichnis
bereich: Virtualisierung
---

**Bind-Mount** = *Bind Mount*
**Deutsch:** Eingebundenes Host-Verzeichnis

## Kurz
Ein beliebiger Ordner des Hosts wird in den Container eingehängt.

## Details
- Syntax: `-v /host/pfad:/container/pfad[:ro]`
- Überdeckt den vorhandenen Inhalt am Zielpfad
- Einsatz: Konfigurationsdateien, Entwicklung; `:ro` = nur lesen

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker run -d -p 8080:80 -v /srv/web:/usr/share/nginx/html:ro nginx:1.27-alpine
```

## Prüfungsfrage
Wann Bind-Mount, wann Volume?

> [!success]- Lösung
> Bind-Mount für Dateien, die der Admin direkt bearbeitet (Konfig); Volume für Anwendungsdaten (Datenbank).

## Siehe auch
[[Volume]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
