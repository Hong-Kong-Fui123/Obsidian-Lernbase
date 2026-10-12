---
title: Docker – Praxis-Lab
tags: [docker, lab, homelab, powershell, validierung]
kapitel: "[[00_Docker-Uebersicht]]"
---

# 09 Docker – Praxis-Lab
← [[08_Docker-Compose]] · → [[10_Docker-Troubleshooting]]

> [!info] Ziel
> Interne Webanwendung `laborweb` im Lab EXAMPLE.COM: Webseite + Datenbank auf EXA-DOCKER01, per DNS-Name erreichbar, mit PowerShell-Validierung vom Windows-Client.

**Inhalt:** [[#Phase 1 Vorbereitung]] · [[#Phase 2 Projekt anlegen]] · [[#Phase 3 Starten]] · [[#Phase 4 DNS-Eintrag]] · [[#Phase 5 PowerShell-Validierung]] · [[#Phase 6 Windows-Container (optional)]] · [[#Phase 7 Aufräumen]] · [[#Checkliste]]

---

## Phase 1 Vorbereitung

| Schritt | Maschine | Aktion |
|---|---|---|
| 1 | Hyper-V-Host | EXA-DOCKER01 anlegen → [[02_Docker-Installation#4 Variante C – Ubuntu-VM (empfohlen)]] |
| 2 | EXA-DOCKER01 | feste IP, z. B. `192.168.10.50/24`, DNS = EXA-DC01 |
| 3 | EXA-DOCKER01 | Docker installieren, `docker run --rm hello-world` |
| 4 | Windows-11-PC | ohne Internet im Lab: Images per `save/load` → [[06_Docker-Volumes-Verzeichnisse#6 Images offline übertragen]] |

Benötigte Images: `nginx:1.27-alpine` · `mariadb:11` · `adminer:latest` · `alpine`

Feste IP (Netplan):
```yaml
# Maschine: EXA-DOCKER01 – /etc/netplan/50-cloud-init.yaml (Schnittstellenname mit "ip a" prüfen)
network:
  version: 2
  ethernets:
    eth0:
      addresses: [192.168.10.50/24]
      routes:
        - to: default
          via: 192.168.10.1
      nameservers:
        addresses: [192.168.10.10]
        search: [example.com]
```
```bash
# Maschine: EXA-DOCKER01
sudo netplan apply && ip a && resolvectl status
```
IPs an dein Lab-Netz anpassen.

---

## Phase 2 Projekt anlegen
```bash
# Maschine: EXA-DOCKER01
mkdir -p ~/projekte/laborweb/web/site ~/projekte/laborweb/backup
cd ~/projekte/laborweb
```
Dateien anlegen (Inhalte aus den Kapiteln kopieren):

| Datei | Quelle |
|---|---|
| `web/Dockerfile` | [[05_Docker-Images-Dockerfile#4 Beispiel eigene Webseite]] |
| `web/site/index.html` | ebenda |
| `web/.dockerignore` | [[05_Docker-Images-Dockerfile#5 dockerignore]] |
| `.env` | [[08_Docker-Compose#3 Beispiel Web + DB + Adminer]] |
| `compose.yaml` | ebenda |

```bash
# Maschine: EXA-DOCKER01
nano web/Dockerfile          # usw.
chmod 600 .env               # Passwörter nur für Besitzer lesbar
docker compose config        # Syntax prüfen
```

---

## Phase 3 Starten
```bash
# Maschine: EXA-DOCKER01
docker compose up -d --build
docker compose ps            # db: (healthy), web: (healthy)
curl -s http://localhost:8080 | head -n 3
```

---

## Phase 4 DNS-Eintrag
```powershell
# Maschine: EXA-DC01
Add-DnsServerResourceRecordA -ZoneName 'example.com' -Name 'docker01' -IPv4Address '192.168.10.50'
Add-DnsServerResourceRecordCName -ZoneName 'example.com' -Name 'laborweb' -HostNameAlias 'docker01.example.com'
Resolve-DnsName laborweb.example.com
```
Aufruf vom Client: `http://laborweb.example.com:8080`

---

## Phase 5 PowerShell-Validierung
Datei `Test-DockerLab.ps1` (Maschine: Windows-11-PC oder EXA-CL01):
```powershell
param(
  [string]$DockerHost = 'docker01.example.com',
  [string]$WebName    = 'laborweb.example.com',
  [int]$WebPort       = 8080,
  [string]$SshUser    = 'admin'
)
$ergebnis = [ordered]@{}

# 1 DNS
$ergebnis['DNS laborweb']   = [bool](Resolve-DnsName $WebName -ErrorAction SilentlyContinue)
# 2 Port erreichbar
$ergebnis['Port offen']     = (Test-NetConnection $DockerHost -Port $WebPort -WarningAction SilentlyContinue).TcpTestSucceeded
# 3 HTTP 200 + Inhalt
try {
  $r = Invoke-WebRequest "http://${WebName}:$WebPort" -UseBasicParsing -TimeoutSec 5
  $ergebnis['HTTP 200']      = $r.StatusCode -eq 200
  $ergebnis['Inhalt korrekt'] = $r.Content -match 'Container'
} catch { $ergebnis['HTTP 200'] = $false; $ergebnis['Inhalt korrekt'] = $false }
# 4 DB-Port NICHT von außen erreichbar (Sicherheit)
$ergebnis['DB nicht offen'] = -not (Test-NetConnection $DockerHost -Port 3306 -WarningAction SilentlyContinue).TcpTestSucceeded
# 5 Container-Status per SSH (OpenSSH-Client ist in Windows enthalten)
$status = ssh "$SshUser@$DockerHost" "docker compose -f ~/projekte/laborweb/compose.yaml ps --format '{{.Service}} {{.Health}}'"
$ergebnis['web healthy']    = [bool]($status -match '^web healthy')
$ergebnis['db healthy']     = [bool]($status -match '^db healthy')

$ergebnis.GetEnumerator() | ForEach-Object {
  '{0,-16} {1}' -f $_.Key, $(if ($_.Value) {'OK'} else {'FEHLER'})
}
```
```powershell
# Maschine: Windows-11-PC
Set-ExecutionPolicy -Scope Process Bypass
.\Test-DockerLab.ps1
```

---

## Phase 6 Windows-Container (optional)
Dockerfile: [[05_Docker-Images-Dockerfile#7 Windows-Image (IIS)]] → `C:\projekte\iisweb\Dockerfile`
```powershell
# Maschine: EXA-DOCKER02
New-Item -ItemType Directory C:\projekte\iisweb\site -Force
Set-Content C:\projekte\iisweb\site\index.html '<h1>IIS im Container auf EXA-DOCKER02</h1>' -Encoding UTF8
Set-Location C:\projekte\iisweb
docker build -t iisweb:1.0 .
docker run -d --name iis01 -p 8080:80 --restart unless-stopped iisweb:1.0
Invoke-WebRequest http://localhost:8080 -UseBasicParsing | Select StatusCode
```
Ausblick Modul 2 (PKI): HTTPS mit Zertifikat von EXA-SRV01 als Reverse-Proxy (nginx) vor den Containern.

---

## Phase 7 Aufräumen
```bash
# Maschine: EXA-DOCKER01
docker compose down          # Daten bleiben im Volume
docker compose down -v       # alles inkl. Datenbank weg
```

---

## Checkliste
- [ ] EXA-DOCKER01 mit fester IP und DNS = EXA-DC01
- [ ] `docker run --rm hello-world` erfolgreich
- [ ] Eigenes Image `meinweb:1.0` gebaut
- [ ] `compose.yaml` läuft, alle Dienste *healthy*
- [ ] DNS `laborweb.example.com` angelegt
- [ ] `Test-DockerLab.ps1` komplett OK
- [ ] Volume gesichert → [[06_Docker-Volumes-Verzeichnisse#7 Volume sichern]]
- [ ] Optional: IIS-Container auf EXA-DOCKER02
