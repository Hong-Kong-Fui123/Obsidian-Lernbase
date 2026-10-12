---
tags: [glossar, docker]
aliases: [Docker-Container]
---
# Container

**Kurz:** Laufende, isolierte Instanz eines Images; teilt sich den Kernel mit dem Host.

- Isolation über Namespaces, Ressourcen über cgroups
- Beschreibbare Schicht geht bei `docker rm` verloren
- Start in Sekunden, Größe in MB

**Siehe auch:** [[Image]] · [[Namespace]] · [[cgroups]] · [[Volume]] · [[00_Docker-Uebersicht]]
