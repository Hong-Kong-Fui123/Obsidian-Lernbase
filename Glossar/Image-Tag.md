---
aliases:
  - Image-Tag
  - Tag
  - Docker-Tag
tags:
  - glossar
  - glossar/virtualisierung
en: Image Tag
de: Versionskennzeichnung eines Images
bereich: Virtualisierung
---

**Image-Tag** = *Image Tag*
**Deutsch:** Versionskennzeichnung eines Images

## Kurz
Bezeichnung nach dem Doppelpunkt im Image-Namen, z. B. `nginx:1.27-alpine`. Kennzeichnet Version oder Variante.

## Details
- Ohne Angabe gilt `latest` – das bedeutet **nicht** automatisch „neueste Version“
- In Produktion feste Tags verwenden (reproduzierbar)
- Ein Image kann mehrere Tags haben

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker tag meinweb:1.0 meinweb:latest
docker images meinweb
```

## Prüfungsfrage
Warum ist `latest` in Produktion riskant?

> [!success]- Lösung
> Nicht reproduzierbar; ein neuer Pull kann unbemerkt eine andere Version liefern.

## Siehe auch
[[Image]] · [[Registry]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
