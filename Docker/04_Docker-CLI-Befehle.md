---
title: Docker – CLI-Befehle
aliases: [Docker Cheatsheet, Docker Befehle]
tags: [docker, cli, powershell, cheatsheet]
kapitel: "[[00_Docker-Uebersicht]]"
---

# 04 Docker – CLI-Befehle
← [[03_Docker-Desktop-GUI]] · → [[05_Docker-Images-Dockerfile]]

Die Befehle sind auf allen Maschinen gleich (EXA-DOCKER01 Bash, Windows-11-PC/EXA-DOCKER02 PowerShell).
Zeilenumbruch: PowerShell `` ` `` · Bash `\`

**Inhalt:** [[#1 Aufbau eines Befehls]] · [[#2 docker run – Optionen]] · [[#3 Container]] · [[#4 Images]] · [[#5 Volumes und Netze]] · [[#6 System und Aufräumen]] · [[#7 Formatierte Ausgabe für PowerShell]]

---

## 1 Aufbau eines Befehls
```text
docker  <Objekt>    <Aktion>  [Optionen]  <Ziel>
docker  container   ls        -a
docker  image       pull                  nginx:1.27-alpine
```
Kurzformen: `docker ps` = `docker container ls` · `docker images` = `docker image ls` · `docker rmi` = `docker image rm`

---

## 2 docker run – Optionen

| Option | Bedeutung | Beispiel |
|---|---|---|
| `-d` | im Hintergrund (detached) | `docker run -d nginx` |
| `--name` | Containername | `--name web01` |
| `-p H:C` | [[Port-Mapping]] Host:Container | `-p 8080:80` |
| `-v` | [[Volume]] / [[Bind-Mount]] | `-v webdaten:/usr/share/nginx/html` |
| `-e` | Umgebungsvariable | `-e TZ=Europe/Berlin` |
| `--env-file` | Variablen aus Datei | `--env-file .env` |
| `--network` | Netz wählen | `--network labnet` |
| `--restart` | [[Restart-Policy]] | `--restart unless-stopped` |
| `-it` | interaktiv mit Terminal | `docker run -it ubuntu bash` |
| `--rm` | nach Ende löschen | `docker run --rm hello-world` |
| `--memory` / `--cpus` | Ressourcen begrenzen ([[cgroups]]) | `--memory 512m --cpus 1` |

Vollständiges Beispiel:
```powershell
# Maschine: Windows-11-PC (PowerShell)
docker run -d --name web01 -p 8080:80 `
  -v webdaten:/usr/share/nginx/html `
  -e TZ=Europe/Berlin --restart unless-stopped `
  nginx:1.27-alpine
```

---

## 3 Container

| Befehl | Zweck |
|---|---|
| `docker ps` / `docker ps -a` | laufende / alle Container |
| `docker start\|stop\|restart <name>` | steuern |
| `docker rm <name>` / `rm -f` | löschen / auch laufend |
| `docker logs -f --tail 50 <name>` | Logs live, letzte 50 Zeilen |
| `docker exec -it <name> sh` | Shell im Container |
| `docker inspect <name>` | alle Details (JSON) |
| `docker stats` | CPU/RAM live |
| `docker top <name>` | Prozesse im Container |
| `docker cp <name>:/pfad .` | Datei herauskopieren |
| `docker port <name>` | Port-Zuordnungen |

---

## 4 Images

| Befehl | Zweck |
|---|---|
| `docker pull nginx:1.27-alpine` | herunterladen |
| `docker images` | lokal anzeigen |
| `docker build -t meinweb:1.0 .` | aus [[Dockerfile]] bauen |
| `docker tag meinweb:1.0 meinweb:latest` | zusätzlichen [[Image-Tag]] setzen |
| `docker push <user>/meinweb:1.0` | in [[Registry]] hochladen (vorher `docker login`) |
| `docker history meinweb:1.0` | [[Image-Layer]] anzeigen |
| `docker save -o web.tar meinweb:1.0` | als Datei exportieren |
| `docker load -i web.tar` | Datei importieren |
| `docker rmi meinweb:1.0` | löschen |

---

## 5 Volumes und Netze

| Befehl | Zweck |
|---|---|
| `docker volume create\|ls\|inspect\|rm <name>` | Volumes verwalten |
| `docker network create labnet` | eigenes [[Bridge-Netzwerk]] |
| `docker network ls` / `inspect labnet` | anzeigen |
| `docker network connect labnet web01` | Container nachträglich verbinden |

---

## 6 System und Aufräumen

| Befehl | Zweck |
|---|---|
| `docker version` / `docker info` | Client/Server, Konfiguration |
| `docker system df` | Speicherverbrauch |
| `docker container prune` | gestoppte Container löschen |
| `docker image prune -a` | ungenutzte Images löschen |
| `docker system prune` | alles Ungenutzte (Volumes nur mit `--volumes`) |

> [!danger] Vorsicht
> `docker system prune -a --volumes` löscht auch Daten in ungenutzten Volumes.

---

## 7 Formatierte Ausgabe für PowerShell
```powershell
# Maschine: Windows-11-PC / EXA-DOCKER02
docker ps --format "{{.Names}}`t{{.Status}}`t{{.Ports}}"   # doppelte Anführungszeichen, sonst kein Tab

# JSON → PowerShell-Objekte
docker ps -a --format '{{json .}}' | ConvertFrom-Json |
  Select-Object Names, Image, State, Status | Format-Table -AutoSize

# IP eines Containers
docker inspect web01 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```
