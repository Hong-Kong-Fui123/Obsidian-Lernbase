---
aliases:
  - cgroups
  - Control Groups
tags:
  - glossar
  - glossar/virtualisierung
en: Control Groups
de: Kontrollgruppen (Ressourcensteuerung)
bereich: Virtualisierung
---

**cgroups** = *Control Groups*
**Deutsch:** Kontrollgruppen (Ressourcensteuerung)

## Kurz
Linux-Kernel-Funktion, die CPU, RAM und I/O von Prozessgruppen begrenzt und misst.

## Details
- Docker: `--memory 512m --cpus 1`
- RAM-Grenze überschritten → Container wird beendet (Exit 137, OOM)
- Zusammen mit [[Namespace|Namespaces]] Basis von Containern

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker run -d --name test --memory 256m --cpus 0.5 nginx:1.27-alpine
docker stats --no-stream test
```

## Prüfungsfrage
Was bedeutet `Exited (137)` mit `OOMKilled: true`?

> [!success]- Lösung
> Der Container hat seine RAM-Grenze überschritten und wurde vom Kernel beendet.

## Siehe auch
[[Namespace]] · [[Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
