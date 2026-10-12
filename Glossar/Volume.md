---
aliases:
  - Volume
  - Docker-Volume
  - Named Volume
tags:
  - glossar
  - glossar/virtualisierung
en: Volume
de: Datenträger für Container
bereich: Virtualisierung
---

**Volume** = *Volume*
**Deutsch:** Datenträger für Container

## Kurz
Von Docker verwalteter Speicher, der unabhängig vom Lebenszyklus eines Containers bestehen bleibt.

## Details
- Linux: `/var/lib/docker/volumes/`, Windows: `C:\ProgramData\docker\volumes\`
- Einsatz: Datenbanken, dauerhafte Anwendungsdaten
- Löschen nur explizit: `docker volume rm` oder `compose down -v`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker volume create dbdaten
docker run -d --name db -e MARIADB_ROOT_PASSWORD=Lab2026! -v dbdaten:/var/lib/mysql mariadb:11
docker volume inspect dbdaten
```

## Prüfungsfrage
Was passiert mit einem Volume, wenn der Container gelöscht wird?

> [!success]- Lösung
> Das Volume bleibt erhalten.

## Siehe auch
[[Bind-Mount]] · [[Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
