---
tags: [glossar, docker]
aliases: [Build Context]
---
# Build-Kontext

**Kurz:** Verzeichnis, das beim `docker build` an den Daemon geschickt wird (meist `.`).

- Nur Dateien darin sind für COPY/ADD verfügbar
- `.dockerignore` schließt Dateien aus (Tempo, keine Geheimnisse)

**Siehe auch:** [[Dockerfile]] · [[00_Docker-Uebersicht]]
