---
aliases:
  - Restart-Policy
  - Neustartrichtlinie
  - --restart
tags:
  - glossar
  - glossar/virtualisierung
en: Restart Policy
de: Neustartrichtlinie
bereich: Virtualisierung
---

**Restart-Policy** = *Restart Policy*
**Deutsch:** Neustartrichtlinie

## Kurz
Regel, ob und wann Docker einen beendeten Container automatisch neu startet.

## Details
- `no` (Standard) · `on-failure[:n]` · `always` · `unless-stopped`
- `unless-stopped`: startet auch nach Host-Neustart, außer manuell gestoppt
- In Compose: `restart: unless-stopped`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker update --restart unless-stopped web01
docker inspect web01 --format '{{.HostConfig.RestartPolicy.Name}}'
```

## Prüfungsfrage
Unterschied `always` und `unless-stopped`?

> [!success]- Lösung
> `always` startet auch nach manuellem Stopp beim Daemon-Neustart wieder, `unless-stopped` nicht.

## Siehe auch
[[Docker-Compose]] · [[Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
