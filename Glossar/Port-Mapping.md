---
tags: [glossar, docker]
aliases: [Port-Weiterleitung, Publish]
---
# Port-Mapping

**Kurz:** Weiterleitung eines Host-Ports auf einen Container-Port.

- `-p 8080:80` = Host 8080 → Container 80
- `EXPOSE` im Dockerfile veröffentlicht nichts
- Prüfen: `docker port <name>`

**Siehe auch:** [[Bridge-Netzwerk]] · [[Container]] · [[00_Docker-Uebersicht]]
