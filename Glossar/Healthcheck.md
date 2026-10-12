---
tags: [glossar, docker]
aliases: [Health Check, Zustandsprüfung]
---
# Healthcheck

**Kurz:** Regelmäßiger Test, ob die Anwendung im Container funktioniert.

- Status: starting → healthy / unhealthy
- Dockerfile `HEALTHCHECK` oder Compose `healthcheck:`
- Compose: `depends_on` mit `condition: service_healthy`

**Siehe auch:** [[Docker-Compose]] · [[Dockerfile]] · [[00_Docker-Uebersicht]]
