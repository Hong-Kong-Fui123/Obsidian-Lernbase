---
aliases:
  - Docker-Daemon
  - dockerd
  - Daemon
tags:
  - glossar
  - glossar/virtualisierung
en: Docker Daemon
de: Docker-Hintergrunddienst
bereich: Virtualisierung
---

**Docker-Daemon** = *Docker Daemon*
**Deutsch:** Docker-Hintergrunddienst

## Kurz
Dienst `dockerd`, der Images, Container, Netzwerke und Volumes verwaltet und Befehle der CLI ausführt.

## Details
- Linux: Dienst `docker`, Socket `/var/run/docker.sock`
- Windows Server: Dienst `docker`, Named Pipe `\\.\pipe\docker_engine`
- Konfiguration: `daemon.json`

## Beispiel
Maschine: **EXA-DOCKER01**
```bash
sudo systemctl status docker
sudo journalctl -u docker -f
```

## Prüfungsfrage
Wo liegt die Daemon-Konfiguration unter Linux?

> [!success]- Lösung
> `/etc/docker/daemon.json`

## Siehe auch
[[Docker-Engine]] · [[API]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
