---
aliases:
  - Bridge-Netzwerk
  - Bridge
  - docker0
tags:
  - glossar
  - glossar/virtualisierung
en: Bridge Network
de: Brücken-Netzwerk
bereich: Virtualisierung
---

**Bridge-Netzwerk** = *Bridge Network*
**Deutsch:** Brücken-Netzwerk

## Kurz
Standard-Netzwerktreiber: privates Netz auf dem Host, nach außen per NAT.

## Details
- Standard-Bridge `docker0`, meist `172.17.0.0/16`, **ohne** Namensauflösung
- Eigene Bridge: Container erreichen sich per Name (DNS `127.0.0.11`)
- Weitere Treiber: `host`, `none`, `macvlan`, `overlay`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker network create labnet
docker run -d --name web01 --network labnet nginx:1.27-alpine
docker run --rm --network labnet alpine ping -c 2 web01
```

## Prüfungsfrage
Warum funktioniert `ping web01` in der Standard-Bridge nicht?

> [!success]- Lösung
> Die Standard-Bridge hat keinen eingebauten DNS; erst ein eigenes Bridge-Netz löst Namen auf.

## Siehe auch
[[Port-Mapping]] · [[Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
