---
aliases:
  - Image-Layer
  - Layer
  - Schicht
tags:
  - glossar
  - glossar/virtualisierung
en: Image Layer
de: Image-Schicht
bereich: Virtualisierung
---

**Image-Layer** = *Image Layer*
**Deutsch:** Image-Schicht

## Kurz
Schreibgeschützte Schicht eines Images. Jede Dockerfile-Anweisung wie `RUN`, `COPY`, `ADD` erzeugt eine neue Schicht.

## Details
- Layer werden gecacht und zwischen Images geteilt (spart Platz)
- Ändert sich ein Layer, werden alle folgenden neu gebaut
- Storage-Treiber unter Linux: `overlay2`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker history meinweb:1.0
ls /var/lib/docker/overlay2 | head
```

## Prüfungsfrage
Warum steht `COPY . /app` besser weit unten im Dockerfile?

> [!success]- Lösung
> Code ändert sich oft; steht er unten, bleiben die Layer darüber im Cache und der Build ist schneller.

## Siehe auch
[[Image]] · [[Dockerfile]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
