---
title: Docker Desktop – GUI-Anleitung
tags: [docker, docker-desktop, gui, windows]
kapitel: "[[00_Docker-Uebersicht]]"
---

# 03 Docker Desktop – GUI-Anleitung
← [[02_Docker-Installation]] · → [[04_Docker-CLI-Befehle]]

Maschine: **Windows-11-PC** mit [[Docker-Desktop]]. Oberfläche englisch.

**Inhalt:** [[#1 Aufbau der Oberfläche]] · [[#2 Erster Container per GUI (nginx)]] · [[#3 Container verwalten]] · [[#4 Images]] · [[#5 Volumes]] · [[#6 Einstellungen (⚙ Settings)]] · [[#7 GUI vs. CLI]]

---

## 1 Aufbau der Oberfläche

| Bereich (links) | Inhalt |
|---|---|
| **Containers** | laufende/gestoppte [[Container]], Logs, Terminal |
| **Images** | lokale [[Image|Images]], Pull, Löschen |
| **Volumes** | [[Volume|Volumes]] mit Inhalt |
| **Builds** | Verlauf von `docker build` |
| **Docker Hub** | Images suchen ([[Docker-Hub]]) |
| **Extensions** | Zusatzwerkzeuge |
| ⚙ **Settings** (oben rechts) | Ressourcen, [[WSL2]], Engine-Konfig |
| Statusleiste unten | Engine-Status, RAM/CPU |

---

## 2 Erster Container per GUI (nginx)
1. Suchfeld oben → `nginx` → Eintrag **nginx (Docker Official Image)**
2. **Pull** → Image erscheint unter *Images*
3. *Images* → Zeile `nginx` → ▶ **Run**
4. **Optional settings** aufklappen:
   - *Container name*: `web01`
   - *Host port*: `8080` (Container-Port 80) → [[Port-Mapping]]
5. **Run** → Browser: `http://localhost:8080` → „Welcome to nginx!“

Entspricht in der [[CLI (Maschine: Windows-11-PC):
```powershell
docker run -d --name web01 -p 8080:80 nginx
```

---

## 3 Container verwalten

| Aktion | GUI | CLI |
|---|---|---|
| Stoppen | ⏹ in der Zeile | `docker stop web01` |
| Starten | ▶ | `docker start web01` |
| Logs | Containername → **Logs** | `docker logs -f web01` |
| Shell im Container | Containername → **Exec** | `docker exec -it web01 sh` |
| Details (IP, Mounts) | Containername → **Inspect** | `docker inspect web01` |
| Dateien | Containername → **Files** | `docker cp web01:/etc/nginx/nginx.conf .` |
| Löschen | 🗑 | `docker rm -f web01` |

---

## 4 Images
- *Images* → **Local**: lokale Images, Spalte *In use*
- Image anklicken → **Layers** zeigt die [[Image-Layer]] und Befehle des [[Dockerfile]]
- **Vulnerabilities**: Sicherheitslücken (Docker Scout)
- Aufräumen: *Images* → **Clean up** (= `docker image prune`)

---

## 5 Volumes
1. *Volumes* → **Create** → Name `webdaten`
2. *Images* → nginx → **Run** → *Optional settings* → *Volumes*:
   - Host path: `webdaten` · Container path: `/usr/share/nginx/html`
3. *Volumes* → `webdaten` → **Stored data**: Dateien ansehen/herunterladen

---

## 6 Einstellungen (⚙ Settings)

| Menü | Wichtig |
|---|---|
| General | *Start Docker Desktop when you sign in*; *Use the WSL 2 based engine* |
| Resources → WSL integration | Docker in eigener Ubuntu-WSL nutzbar machen |
| Resources → Advanced | Speicherort des Disk-Images |
| Docker Engine | JSON-Editor = `daemon.json` → [[06_Docker-Volumes-Verzeichnisse#5 Konfigurationsdateien]] |
| Kubernetes | lokaler Ein-Knoten-[[Kubernetes]]-Cluster |
| Troubleshoot (🐞) | *Restart*, *Clean / Purge data*, *Reset to factory defaults* |

Windows-Container: Rechtsklick auf Wal-Symbol (Taskleiste) → **Switch to Windows containers…**

---

## 7 GUI vs. CLI
- GUI: gut zum Ansehen und Lernen.
- Im Job: **CLI und Compose**, weil wiederholbar, skriptbar, auf Servern ohne GUI.
- Merke: Jede GUI-Aktion hat einen CLI-Befehl → [[04_Docker-CLI-Befehle]].
