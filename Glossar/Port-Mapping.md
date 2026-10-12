---
aliases:
  - Port-Mapping
  - Port-Weiterleitung
  - Publish
tags:
  - glossar
  - glossar/virtualisierung
en: Port Mapping / Publishing
de: Port-Weiterleitung
bereich: Virtualisierung
---

**Port-Mapping** = *Port Mapping / Publishing*
**Deutsch:** Port-Weiterleitung

## Kurz
Leitet einen Port des Hosts auf einen Port im Container weiter und macht den Dienst von außen erreichbar.

## Details
- `-p 8080:80` = Host-Port 8080 → Container-Port 80
- `-p 127.0.0.1:8080:80` = nur lokal erreichbar
- `EXPOSE` im Dockerfile ist nur Dokumentation

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker run -d --name web -p 8080:80 nginx:1.27-alpine
docker port web
```

## Prüfungsfrage
Reicht `EXPOSE 80` im Dockerfile, um die Webseite zu erreichen?

> [!success]- Lösung
> Nein, erst `-p` beim Start veröffentlicht den Port.

## Siehe auch
[[Bridge-Netzwerk]] · [[Container]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
