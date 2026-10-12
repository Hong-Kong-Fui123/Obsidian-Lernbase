---
tags: [glossar, docker]
aliases: [Multistage, mehrstufiger Build]
---
# Multi-Stage-Build

**Kurz:** Dockerfile mit mehreren FROM-Stufen; nur das Ergebnis kommt ins finale Image.

- `FROM sdk AS build` … `COPY --from=build`
- Kleinere, sicherere Images ohne Bauwerkzeuge

**Siehe auch:** [[Dockerfile]] · [[Image]] · [[00_Docker-Uebersicht]]
