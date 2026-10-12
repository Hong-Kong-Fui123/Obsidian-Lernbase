---
aliases:
  - Healthcheck
  - Health Check
  - Zustandsprüfung
tags:
  - glossar
  - glossar/virtualisierung
en: Health Check
de: Zustandsprüfung
bereich: Virtualisierung
---

**Healthcheck** = *Health Check*
**Deutsch:** Zustandsprüfung

## Kurz
Regelmäßiger Test, ob die Anwendung im Container wirklich funktioniert – nicht nur, ob der Prozess läuft.

## Details
- Status: `starting` → `healthy` / `unhealthy`
- Im Dockerfile `HEALTHCHECK` oder in Compose `healthcheck:`
- Compose: `depends_on` mit `condition: service_healthy`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker inspect web01 --format '{{.State.Health.Status}}'
```

## Prüfungsfrage
Warum reicht `docker ps` mit Status `Up` nicht als Funktionsnachweis?

> [!success]- Lösung
> Der Prozess kann laufen, obwohl die Anwendung hängt oder Fehler liefert.

## Siehe auch
[[Docker-Compose]] · [[Dockerfile]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
