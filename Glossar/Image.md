---
aliases:
  - Image
  - Docker-Image
  - Container-Image
tags:
  - glossar
  - glossar/virtualisierung
en: Container Image
de: Container-Abbild
bereich: Virtualisierung
---

**Image** = *Container Image*
**Deutsch:** Container-Abbild

## Kurz
Schreibgeschützter Bauplan eines Containers, aufgebaut aus übereinanderliegenden [[Image-Layer|Layern]].

## Details
- Name: `registry/repository:tag`, z. B. `docker.io/library/nginx:1.27-alpine`
- Entsteht mit `docker build` oder wird mit `docker pull` geladen
- Aus einem Image können beliebig viele Container starten

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker pull nginx:1.27-alpine
docker images
docker history nginx:1.27-alpine
```

## Prüfungsfrage
Wie viele Container kann man aus einem Image starten?

> [!success]- Lösung
> Beliebig viele; jeder bekommt seine eigene beschreibbare Schicht.

## Siehe auch
[[Container]] · [[Image-Tag]] · [[Dockerfile]] · [[Registry]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
