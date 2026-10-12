---
tags: [glossar, docker]
aliases: [CMD, ENTRYPOINT]
---
# CMD-ENTRYPOINT

**Kurz:** Dockerfile-Anweisungen für den Startbefehl eines Containers.

- ENTRYPOINT: fester Programmaufruf · CMD: Standard-Argumente, überschreibbar
- Exec-Form bevorzugen: `CMD ["nginx", "-g", "daemon off;"]`
- Hauptprozess muss im Vordergrund laufen, sonst endet der Container

**Siehe auch:** [[Dockerfile]] · [[00_Docker-Uebersicht]]
