---
aliases:
  - Registry
  - Container-Registry
tags:
  - glossar
  - glossar/virtualisierung
en: Container Registry
de: Image-Ablage
bereich: Virtualisierung
---

**Registry** = *Container Registry*
**Deutsch:** Image-Ablage

## Kurz
Server, der Images speichert und verteilt.

## Details
- Öffentlich: [[Docker-Hub]], `mcr.microsoft.com`, `ghcr.io`
- Privat: eigene Registry, Azure Container Registry (ACR)
- Anmeldung: `docker login <registry>`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
docker pull mcr.microsoft.com/dotnet/aspnet:8.0
docker push registry.example.com/team/meinweb:1.0
```

## Prüfungsfrage
Welche Registry nutzt Docker, wenn keine angegeben ist?

> [!success]- Lösung
> Docker Hub (`docker.io`).

## Siehe auch
[[Docker-Hub]] · [[Image]] · [[Image-Tag]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
