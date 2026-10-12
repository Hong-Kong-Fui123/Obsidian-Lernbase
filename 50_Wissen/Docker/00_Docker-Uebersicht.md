---
title: Docker – Kapitelübersicht
aliases: [Docker, Docker Kapitel, Container Kapitel]
tags: [docker, container, kapitel, moc]
modul: Docker & Virtualisierung
erstellt: 2026-10-12
status: aktiv
---

# Docker – Kapitelübersicht

> [!info] Lernziel
> Container verstehen, Docker installieren (Windows & Linux), Images bauen, Daten und Netzwerke verwalten, Mehrcontainer-Anwendungen mit Compose betreiben, Fehler finden.

## Lernpfad

| Nr. | Notiz | Inhalt | Zeit |
|---|---|---|---|
| 01 | [[01_Docker-Grundlagen]] | Container vs. VM, Architektur | 60 Min |
| 02 | [[02_Docker-Installation]] | Docker Desktop · Server 2025 · Ubuntu | 60 Min |
| 03 | [[03_Docker-Desktop-GUI]] | GUI-Anleitung Schritt für Schritt | 30 Min |
| 04 | [[04_Docker-CLI-Befehle]] | Befehlsreferenz | 60 Min |
| 05 | [[05_Docker-Images-Dockerfile]] | Images bauen, Dockerfile | 60 Min |
| 06 | [[06_Docker-Volumes-Verzeichnisse]] | Daten, Verzeichnisse, Konfig-Dateien | 60 Min |
| 07 | [[07_Docker-Netzwerk]] | Netzwerktreiber, Ports, DNS | 60 Min |
| 08 | [[08_Docker-Compose]] | Mehrcontainer-Anwendungen | 120 Min |
| 09 | [[09_Docker-Praxis-Lab]] | Home-Lab-Projekt + PowerShell-Validierung | 120 Min |
| 10 | [[10_Docker-Troubleshooting]] | Fehlersuche | 30 Min |
| 11 | [[11_Docker-Aufgaben]] | Übungen mit Lösungen | 60 Min |
| 12 | [[12_Docker-Klausur]] | Prüfung | 45 Min |

## Lab-Maschinen

| Maschine | System | Zweck | Status |
|---|---|---|---|
| EXA-DOCKER01 | Ubuntu Server 24.04 (Hyper-V-VM) | **Linux-Container** (Hauptübung) | 📋 |
| EXA-DOCKER02 | Windows Server 2025 (Hyper-V-VM) | **Windows-Container** (IIS) | 📋 |
| Windows-11-PC | Windows 11 + Docker Desktop | **GUI** + Linux-Container über [[WSL2]] | 📋 |

> [!warning] Lab ohne Internet
> Images kommen aus einer [[Registry]] im Internet. Ohne Internet: Images auf einem Rechner mit Internet laden und per `docker save` / `docker load` übertragen → [[06_Docker-Volumes-Verzeichnisse#6 Images offline übertragen]].

## Begriffe des Kapitels
[[Docker]] · [[Container]] · [[Image]] · [[Image-Layer]] · [[Image-Tag]] · [[Dockerfile]] · [[Build-Kontext]] · [[Multi-Stage-Build]] · [[Docker-Engine]] · [[Docker-Daemon]] · [[Containerd]] · [[OCI]] · [[Docker-Desktop]] · [[WSL2]] · [[Registry]] · [[Docker-Hub]] · [[Volume]] · [[Bind-Mount]] · [[Port-Mapping]] · [[Bridge-Netzwerk]] · [[Namespace]] · [[cgroups]] · [[Docker-Compose]] · [[Restart-Policy]] · [[Healthcheck]] · [[CMD-ENTRYPOINT]] · [[Windows-Container]] · [[Prozess-Isolation]] · [[Hyper-V-Isolation]] · [[Orchestrierung]] · [[Kubernetes]]

Übersicht: [[00_Glossar-Index]]

## Bezug zu anderen Themen
- [[HyperV-VM-Export-Import]] – VM-Umzug vs. Image-Transport
- [[CLI]] · [[API]] · [[CI-CD]]
