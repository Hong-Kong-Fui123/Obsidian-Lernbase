---
tags: [glossar, docker]
aliases: [Bridge, docker0]
---
# Bridge-Netzwerk

**Kurz:** Standard-Netztreiber: privates Netz auf dem Host mit NAT nach außen.

- Standard-Bridge `docker0`, meist 172.17.0.0/16, ohne Namensauflösung
- Eigene Bridge: DNS per Containername
- `docker network create <name>`

**Siehe auch:** [[Port-Mapping]] · [[Container]] · [[00_Docker-Uebersicht]]
