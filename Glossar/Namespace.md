---
aliases:
  - Namespace
  - Linux-Namespace
tags:
  - glossar
  - glossar/virtualisierung
en: Namespace
de: Namensraum (Isolationsbereich)
bereich: Virtualisierung
---

**Namespace** = *Namespace*
**Deutsch:** Namensraum (Isolationsbereich)

## Kurz
Linux-Kernel-Funktion, die einem Prozess eine eigene, abgeschottete Sicht auf Systemressourcen gibt.

## Details
- `pid`: eigene Prozessliste · `net`: eigenes Netzwerk · `mnt`: eigenes Dateisystem
- `uts`: eigener Hostname · `ipc`, `user`: Kommunikation, Benutzer-IDs
- Grundlage der Container-Isolation

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker run --rm alpine ps   # sieht nur eigene Prozesse
```

## Prüfungsfrage
Welcher Namespace sorgt dafür, dass ein Container nur seine eigenen Prozesse sieht?

> [!success]- Lösung
> Der PID-Namespace.

## Siehe auch
[[cgroups]] · [[Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
