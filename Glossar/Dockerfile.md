---
tags: [glossar, docker]
aliases: [Docker-Datei]
---
# Dockerfile

**Kurz:** Textdatei mit Bauanweisungen für ein Image (FROM, COPY, RUN, CMD …).

- Bauen: `docker build -t name:tag .`
- Reihenfolge: selten Geändertes oben (Layer-Cache)

**Siehe auch:** [[Image-Layer]] · [[Build-Kontext]] · [[Multi-Stage-Build]] · [[CMD-ENTRYPOINT]] · [[00_Docker-Uebersicht]]
