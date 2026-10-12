---
tags: [glossar, docker]
aliases: [Control Groups]
---
# cgroups

**Kurz:** Kernel-Funktion, die Ressourcen (CPU, RAM, I/O) von Prozessgruppen begrenzt und misst.

- Docker: `--memory 512m --cpus 1`
- Überschreitung RAM → Container wird beendet (Exit 137, OOM)

**Siehe auch:** [[Namespace]] · [[Container]] · [[00_Docker-Uebersicht]]
