---
aliases:
  - CMD-ENTRYPOINT
  - CMD
  - ENTRYPOINT
tags:
  - glossar
  - glossar/virtualisierung
en: CMD / ENTRYPOINT
de: Startbefehl eines Containers
bereich: Virtualisierung
---

**CMD-ENTRYPOINT** = *CMD / ENTRYPOINT*
**Deutsch:** Startbefehl eines Containers

## Kurz
Dockerfile-Anweisungen, die festlegen, welcher Prozess beim Start des Containers läuft.

## Details
- `ENTRYPOINT`: festes Programm · `CMD`: Standard-Argumente, beim Start überschreibbar
- Exec-Form bevorzugen: `CMD ["nginx", "-g", "daemon off;"]`
- Der Hauptprozess muss im Vordergrund laufen, sonst endet der Container

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker run --rm alpine echo Hallo   # überschreibt CMD
```

## Prüfungsfrage
Warum beendet sich ein Container sofort mit `Exited (0)`?

> [!success]- Lösung
> Der Hauptprozess ist fertig oder läuft im Hintergrund; der Container lebt nur so lange wie sein Hauptprozess.

## Siehe auch
[[Dockerfile]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
