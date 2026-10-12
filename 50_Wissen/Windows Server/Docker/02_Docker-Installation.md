---
title: Docker – Installation
tags: [docker, installation, powershell, hyper-v, wsl2]
kapitel: "[[00_Docker-Uebersicht]]"
---

# 02 Docker – Installation
← [[01_Docker-Grundlagen]] · → [[03_Docker-Desktop-GUI]]

**Inhalt:** [[#1 Welche Variante]] · [[#2 Variante A – Docker Desktop (Windows 11)]] · [[#3 Variante B – Windows Server 2025]] · [[#4 Variante C – Ubuntu-VM (empfohlen)]] · [[#5 Prüfen]]

---

## 1 Welche Variante

| Variante | Maschine | Container-Typ | GUI | Lizenz |
|---|---|---|---|---|
| A [[Docker-Desktop]] | Windows-11-PC | Linux (über [[WSL2]]) + Windows | ja | kostenlos privat/Lernen; Firmen ab 250 Mitarbeitenden oder 10 Mio. USD Umsatz kostenpflichtig |
| B Docker CE | EXA-DOCKER02 (Server 2025) | nur [[Windows-Container]] | nein | kostenlos |
| C Docker Engine | EXA-DOCKER01 (Ubuntu) | Linux | nein | kostenlos |

> [!tip] Empfehlung
> Hauptübung auf **C** (so läuft Docker in Firmen und in der Cloud). **A** für die GUI, **B** für Windows-Container mit IIS.
> Docker Desktop läuft **nicht** auf Windows Server.

---

## 2 Variante A – Docker Desktop (Windows 11)

### 2.1 Voraussetzungen
- Virtualisierung im BIOS/UEFI aktiv (VT-x/AMD-V)
- Ist der PC selbst eine Hyper-V-VM → verschachtelte Virtualisierung nötig (siehe 3.1)

### 2.2 PowerShell (Admin)
```powershell
# Maschine: Windows-11-PC
wsl --install                       # WSL2 + Ubuntu, danach Neustart
wsl --status                        # Standardversion 2?
winget install -e --id Docker.DockerDesktop
# Abmelden/anmelden, Docker Desktop starten, Lizenzbedingungen bestätigen
docker version
```

### 2.3 GUI
1. https://www.docker.com/products/docker-desktop → *Download for Windows*
2. Installer: Haken **Use WSL 2 instead of Hyper-V** gesetzt lassen
3. Neustart → Docker Desktop starten → *Accept*
4. Anmelden optional (*Skip*)
5. Wal-Symbol in der Taskleiste grün = Engine läuft → weiter mit [[03_Docker-Desktop-GUI]]

---

## 3 Variante B – Windows Server 2025

### 3.1 VM anlegen
```powershell
# Maschine: Hyper-V-Host
New-VM -Name EXA-DOCKER02 -Generation 2 -MemoryStartupBytes 4GB `
  -NewVHDPath 'D:\Hyper-V\EXA-DOCKER02\EXA-DOCKER02.vhdx' -NewVHDSizeBytes 60GB `
  -SwitchName 'LabSwitch'
Set-VMProcessor -VMName EXA-DOCKER02 -Count 2
# Nur nötig für Hyper-V-Isolation im Gast:
Set-VMProcessor -VMName EXA-DOCKER02 -ExposeVirtualizationExtensions $true
Add-VMDvdDrive -VMName EXA-DOCKER02 -Path 'D:\ISO\WinServer2025.iso'
```
Danach Windows Server 2025 installieren, IP vergeben, Domäne beitreten.

### 3.2 Docker CE installieren (braucht Internet)
```powershell
# Maschine: EXA-DOCKER02 (PowerShell als Admin)
Invoke-WebRequest -UseBasicParsing `
  'https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1' `
  -OutFile install-docker-ce.ps1
.\install-docker-ce.ps1          # aktiviert Feature "Containers", installiert Docker, Neustart
# nach dem Neustart erneut ausführen, falls das Skript es verlangt
Get-Service docker
docker version
```

---

## 4 Variante C – Ubuntu-VM (empfohlen)

### 4.1 VM anlegen
```powershell
# Maschine: Hyper-V-Host
New-VM -Name EXA-DOCKER01 -Generation 2 -MemoryStartupBytes 4GB `
  -NewVHDPath 'D:\Hyper-V\EXA-DOCKER01\EXA-DOCKER01.vhdx' -NewVHDSizeBytes 40GB `
  -SwitchName 'LabSwitch'
Set-VMProcessor -VMName EXA-DOCKER01 -Count 2
Set-VMFirmware  -VMName EXA-DOCKER01 -SecureBootTemplate MicrosoftUEFICertificateAuthority   # Pflicht für Linux
Add-VMDvdDrive  -VMName EXA-DOCKER01 -Path 'D:\ISO\ubuntu-24.04-live-server-amd64.iso'
Set-VMFirmware  -VMName EXA-DOCKER01 -FirstBootDevice (Get-VMDvdDrive -VMName EXA-DOCKER01)
Start-VM EXA-DOCKER01
```
Ubuntu-Installer: Haken **Install OpenSSH server** setzen.

### 4.2 Docker installieren
```bash
# Maschine: EXA-DOCKER01 (Bash, per SSH vom Windows-PC: ssh admin@EXA-DOCKER01)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER     # docker ohne sudo – danach ab- und anmelden
sudo systemctl enable --now docker
docker version
```

> [!warning] Gruppe `docker` = Root-Rechte
> Wer in der Gruppe `docker` ist, kann den Host komplett übernehmen. Nur Admins aufnehmen.

---

## 5 Prüfen

| Befehl | Erwartung |
|---|---|
| `docker version` | Abschnitt **Client** und **Server** vorhanden |
| `docker info` | `OSType: linux` bzw. `windows` |
| `docker run --rm hello-world` | Text „Hello from Docker!“ (Linux) |

```powershell
# Maschine: Windows-11-PC oder EXA-DOCKER02
$ok = $true
try { $os = docker info --format '{{.OSType}}'; "OSType: $os" } catch { $ok = $false }
if ($LASTEXITCODE -ne 0) { $ok = $false }
'Docker-Engine erreichbar: ' + $(if ($ok) {'OK'} else {'FEHLER – Dienst/Docker Desktop gestartet?'})
```
