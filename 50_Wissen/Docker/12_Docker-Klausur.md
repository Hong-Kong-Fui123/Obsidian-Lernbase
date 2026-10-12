---
title: Docker – Klausur
tags: [docker, klausur]
kapitel: "[[00_Docker-Uebersicht]]"
---

# 12 Docker – Klausur
← [[11_Docker-Aufgaben]] · ↑ [[00_Docker-Uebersicht]]

**Zeit: 45 Min · 50 Punkte · Hilfsmittel: keine**
Bestanden ab 25 Punkten. Bei jedem Befehl Maschine angeben.

---

## Teil A – Wissen (20 P)
1. Nenne drei Unterschiede zwischen Container und VM. *(3 P)*
2. Erkläre Image, Container und Registry in je einem Satz. *(3 P)*
3. Was bewirkt `EXPOSE 80` im Dockerfile – und was nicht? *(2 P)*
4. Unterschied Volume und Bind-Mount, je ein Einsatzzweck. *(4 P)*
5. Warum braucht Docker Desktop unter Windows WSL2 für Linux-Container? *(2 P)*
6. Welche Linux-Kernel-Funktionen isolieren Container? Je eine Aufgabe. *(4 P)*
7. Was bedeutet der Tag `latest`? Warum ist er in Produktion ungeeignet? *(2 P)*

## Teil B – Befehle (15 P)
8. Container `wiki` aus Image `requarks/wiki:2` im Hintergrund, Port 3000 → Host 8000, Neustart außer bei manuellem Stopp. *(4 P)*
9. Image `meinweb:1.0` aus dem aktuellen Ordner bauen. *(2 P)*
10. Letzte 50 Logzeilen von `wiki` live verfolgen. *(2 P)*
11. Shell im laufenden Container `wiki` öffnen. *(2 P)*
12. Image `mariadb:11` als Datei exportieren und auf einem anderen Host importieren. *(3 P)*
13. Speicherverbrauch von Docker anzeigen. *(2 P)*

## Teil C – Praxis (15 P)
14. Schreibe eine `compose.yaml`: Dienst `web` (nginx:1.27-alpine, Port 8080→80, Bind-Mount `./site` read-only nach `/usr/share/nginx/html`) und Dienst `db` (mariadb:11, Volume `dbdaten`, Root-Passwort aus `.env`, kein veröffentlichter Port). *(10 P)*
15. Schreibe zwei PowerShell-Zeilen, die vom Windows-Client prüfen, ob Port 8080 auf `docker01.example.com` offen ist und die Webseite HTTP 200 liefert. *(5 P)*

---

> [!success]- Lösungen
> **A**
> 1. Kernel geteilt vs. eigen · MB vs. GB · Sekunden vs. Minuten · Isolation schwächer vs. stärker
> 2. Image: schreibgeschützter Bauplan aus Layern. Container: laufende Instanz eines Images mit beschreibbarer Schicht. Registry: Ablage für Images (Docker Hub).
> 3. Dokumentiert den Port; veröffentlicht ihn **nicht** (dafür `-p`).
> 4. Volume: von Docker verwaltet, Datenbanken. Bind-Mount: Host-Pfad, Konfig-Dateien/Entwicklung.
> 5. Linux-Container brauchen einen Linux-Kernel, WSL2 liefert ihn in einer leichten VM.
> 6. [[Namespace]]: trennt Sicht (Prozesse, Netz, Dateisystem). [[cgroups]]: begrenzen Ressourcen (CPU, RAM).
> 7. Standard-Tag, nicht zwingend neueste Version; nicht reproduzierbar, Updates unkontrolliert.
>
> **B** (Maschine: EXA-DOCKER01)
> 8. `docker run -d --name wiki -p 8000:3000 --restart unless-stopped requarks/wiki:2`
> 9. `docker build -t meinweb:1.0 .`
> 10. `docker logs -f --tail 50 wiki`
> 11. `docker exec -it wiki sh`
> 12. Quelle: `docker save -o mariadb.tar mariadb:11` · Ziel: `docker load -i mariadb.tar`
> 13. `docker system df`
>
> **C**
> ```yaml
> services:
>   web:
>     image: nginx:1.27-alpine
>     ports:
>       - "8080:80"
>     volumes:
>       - ./site:/usr/share/nginx/html:ro
>   db:
>     image: mariadb:11
>     environment:
>       MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
>     volumes:
>       - dbdaten:/var/lib/mysql
> volumes:
>   dbdaten:
> ```
> ```powershell
> # Maschine: Windows-11-PC
> (Test-NetConnection docker01.example.com -Port 8080).TcpTestSucceeded
> (Invoke-WebRequest http://docker01.example.com:8080 -UseBasicParsing).StatusCode -eq 200
> ```
