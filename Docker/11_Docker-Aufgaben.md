---
title: Docker – Aufgaben
tags: [docker, aufgabe]
kapitel: "[[00_Docker-Uebersicht]]"
---

# 11 Docker – Aufgaben
← [[10_Docker-Troubleshooting]] · → [[12_Docker-Klausur]]

Erst selbst versuchen, dann Hinweis, dann Lösung.

---

### A1 – Container vs. VM
Du sollst für EXAMPLE.COM einen zweiten Domain Controller und ein internes Wiki bereitstellen. Was als VM, was als Container? Begründe.
> [!hint]- Hinweis
> Welcher Dienst braucht ein komplettes Windows-Betriebssystem mit Domänenrolle?

> [!success]- Lösung
> DC → VM (eigenes OS, AD DS, Kerberos, Replikation). Wiki → Container (einzelner Dienst, schnell austauschbar). → [[01_Docker-Grundlagen#2 Container vs. VM]]

### A2 – Erster Container
Starte nginx so, dass er auf Port 8888 erreichbar ist, `web-test` heißt und nach einem Neustart des Hosts wieder startet.
> [!hint]- Hinweis
> Du brauchst vier Optionen: Hintergrund, Name, Port, Neustart.

> [!success]- Lösung
> ```bash
> # Maschine: EXA-DOCKER01
> docker run -d --name web-test -p 8888:80 --restart unless-stopped nginx:1.27-alpine
> ```

### A3 – Daten überleben
Starte MariaDB, lege eine Datenbank an, lösche den Container, starte ihn neu. Die Datenbank soll noch da sein.
> [!hint]- Hinweis
> Wo speichert MariaDB im Container? Was muss dort hin?

> [!success]- Lösung
> ```bash
> # Maschine: EXA-DOCKER01
> docker run -d --name db -e MARIADB_ROOT_PASSWORD=Test123! -v dbtest:/var/lib/mysql mariadb:11
> docker exec -it db mariadb -uroot -pTest123! -e "CREATE DATABASE schule;"
> docker rm -f db
> docker run -d --name db -e MARIADB_ROOT_PASSWORD=Test123! -v dbtest:/var/lib/mysql mariadb:11
> docker exec -it db mariadb -uroot -pTest123! -e "SHOW DATABASES;"
> ```
> → [[06_Docker-Volumes-Verzeichnisse#2 Volumes]]

### A4 – Namensauflösung
Zwei Container `app` und `cache` sollen sich per Name anpingen. Mit der Standard-Bridge klappt es nicht. Warum, und wie löst du es?
> [!success]- Lösung
> Standard-Bridge hat keinen eingebauten DNS. Eigenes Netz: `docker network create appnet`, beide mit `--network appnet` starten. → [[07_Docker-Netzwerk#3 Eigenes Bridge-Netz mit DNS]]

### A5 – Dockerfile-Fehler
Finde drei Schwachstellen:
```dockerfile
FROM ubuntu:latest
COPY . /app
RUN apt-get update
RUN apt-get install -y python3
ENV DB_PASSWORD=Geheim123
CMD python3 /app/main.py
```
> [!hint]- Hinweis
> Denk an Tags, Layer-Cache, Geheimnisse, Benutzer.

> [!success]- Lösung
> - `latest` → fester Tag (`ubuntu:24.04`) oder kleineres Basis-Image (`python:3.12-slim`)
> - `COPY .` vor Paketinstallation → jede Code-Änderung baut alles neu; `.dockerignore` fehlt
> - `apt-get update` und `install` getrennt → veralteter Cache; zusammenfassen mit `&&` und `rm -rf /var/lib/apt/lists/*`
> - Passwort im Image → zur Laufzeit per `-e`/Secret
> - Läuft als root → `USER`
> - Shell-Form `CMD` → Exec-Form `CMD ["python3", "/app/main.py"]` → [[CMD-ENTRYPOINT]]

### A6 – Offline-Lab
Das Home-Lab hat kein Internet. Bringe `alpine:3.20` auf EXA-DOCKER01. Maschinen angeben.
> [!success]- Lösung
> Windows-11-PC: `docker pull alpine:3.20` → `docker save -o alpine.tar alpine:3.20` → Datei übertragen (`scp alpine.tar admin@EXA-DOCKER01:~`) → EXA-DOCKER01: `docker load -i alpine.tar`

### A7 – Compose-Fehler
`docker compose up -d` meldet: `found character that cannot start any token`. Ursache?
> [!success]- Lösung
> Tabulator in der YAML-Datei. Nur Leerzeichen verwenden. → [[08_Docker-Compose#6 Typische Fehler]]

### A8 – Sicherheit
Warum soll der DB-Container im Praxis-Lab **keine** `ports` haben? Wie prüfst du das mit PowerShell?
> [!success]- Lösung
> Nur `adminer` und `web` brauchen die DB, intern über das Netz `backend`. Offener Port = Angriffsfläche.
> Windows-11-PC: `Test-NetConnection docker01.example.com -Port 3306` → `TcpTestSucceeded : False`

### A9 – Exit-Code
`docker ps -a` zeigt `Exited (137)`. Was prüfst du?
> [!success]- Lösung
> `docker inspect <name> --format '{{.State.OOMKilled}}'` → `true` = Speicherlimit zu klein. → [[10_Docker-Troubleshooting]]

### A10 – Windows-Container
Auf EXA-DOCKER02 (Server 2025) startet ein Image mit Tag `ltsc2022` nicht mit Prozess-Isolation. Warum, und welche zwei Lösungen gibt es?
> [!success]- Lösung
> Kernel-Version von Image und Host verschieden. Lösung 1: `ltsc2025`-Image. Lösung 2: `--isolation=hyperv` (braucht Virtualisierung, in VM: verschachtelte Virtualisierung). → [[Prozess-Isolation]] · [[Hyper-V-Isolation]]
