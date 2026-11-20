---
aliases: [Hybrid AZ-802]
tags: [az-802, az-802/hybrid, thema]
bereich: 02
gewicht: 10–15 %
status: offen
---
# 02 Windows Server in Hybridumgebung verwalten (10–15 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 02 Hybrid - Aufgaben]]

## Prüfungsziele
- [ ] Windows Admin Center lokal + im Azure-Portal
- [ ] PowerShell-Remoting inkl. Double-Hop und JEA
- [ ] Remote-SSH
- [ ] Remotedesktop
- [ ] Azure Arc-fähige Server
- [ ] Gerätekonfiguration (Machine Configuration) via Arc
- [ ] VM-Erweiterungen auf Nicht-Azure-Computern
- [ ] Azure Update Manager
- [ ] Azure Automation Runbooks

## Kernwissen

### Windows Admin Center (WAC)
| Modus | Wo | Merkpunkt |
|---|---|---|
| Gateway-Server | eigener Server | zentraler Zugriff, Port 443 |
| Desktop | Windows 10/11 | nur lokal |
| Im Azure-Portal | Azure-VM / Arc-Server | Erweiterung, Zugriff per Entra-ID + RBAC-Rolle *Windows Admin Center Administrator Login* |
- Zertifikat für Gateway: selbstsigniert (60 Tage) oder aus eigener CA → PKI-Bezug.

### PowerShell-Remoting
- WinRM: HTTP **5985**, HTTPS **5986**. Aktivieren: `Enable-PSRemoting`.
- Arbeitsgruppe/fremde Domäne: `TrustedHosts` oder HTTPS.
- **Double-Hop-Problem**: Anmeldedaten werden nicht an 3. Server weitergereicht.

| Lösung Double-Hop | Bewertung |
|---|---|
| Ressourcenbasierte Kerberos-eingeschränkte Delegierung (RBKCD) | **empfohlen** |
| Kerberos eingeschränkte Delegierung | ok, mehr Aufwand |
| CredSSP | unsicher (Anmeldedaten im Speicher) |
| `-Credential` im ScriptBlock / JEA RunAs | Workaround |

### JEA (Just Enough Administration)
| Datei | Endung | Inhalt |
|---|---|---|
| Rollenfunktionsdatei | `.psrc` | erlaubte Cmdlets/Parameter (in Modul-Ordner `RoleCapabilities`) |
| Sitzungskonfiguration | `.pssc` | `SessionType RestrictedRemoteServer`, `RunAsVirtualAccount`, RoleDefinitions |
- Registrieren: `Register-PSSessionConfiguration -Name X -Path .\X.pssc`. Verbinden: `Enter-PSSession -ConfigurationName X`.
- Transkript-Ordner für Auditing.

### SSH
- OpenSSH-Server: `Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0`, Dienst `sshd`, Port 22.
- Konfig: `C:\ProgramData\ssh\sshd_config`. Admin-Keys: `administrators_authorized_keys`.
- PowerShell über SSH: `Enter-PSSession -HostName ... -UserName ...` (PS 7).

### Remotedesktop
- Port 3389, **NLA** aktivieren. RD Gateway (443) für extern. In Azure: Bastion statt öffentlicher IP.

### Azure Arc
- Agent **Connected Machine Agent** (`azcmagent`). Onboarding: Skript aus Portal, Dienstprinzipal für Massen-Onboarding.
- Ausgehend **443** nötig (kein eingehender Port). Proxy möglich.
- Ergebnis: Ressource *Microsoft.HybridCompute/machines* mit verwalteter Identität.
- Nutzt: Azure Policy, Machine Configuration, Update Manager, Monitor, Defender, Erweiterungen.

### Machine Configuration (früher Guest Configuration)
- Azure Policy mit DSC-basierter Prüfung/Durchsetzung *im* Betriebssystem. Modi: Audit / ApplyAndMonitor / ApplyAndAutoCorrect.

### VM-Erweiterungen auf Arc
- z. B. Azure Monitor Agent (AMA), Custom Script, Defender for Endpoint, Key Vault, WAC.
- `New-AzConnectedMachineExtension`. Status in Portal/`azcmagent show`.

### Azure Update Manager
- Bewertung (periodisch alle 24 h möglich) + Installation; **Wartungskonfiguration** für Zeitplan.
- Patch-Orchestrierung: *Customer Managed Schedules*. Pre/Post-Ereignisse.
- Für Arc-Server kostenpflichtig pro Server/Monat (außer bestimmte Lizenzen).

### Azure Automation
- Automation-Konto, Runbook-Typen: PowerShell, Python, Grafisch.
- **Hybrid Runbook Worker** (erweiterungsbasiert) → Runbook läuft lokal.
- Authentifizierung: **verwaltete Identität** (Run-As-Konten abgekündigt).

## Prüfungsfallen
- Arc braucht **keinen** eingehenden Port.
- CredSSP „funktioniert“, ist aber nie die empfohlene Antwort.
- JEA: `.psrc` = Was, `.pssc` = Wie/Wer.
- Update Manager ersetzt Update Management (Log-Analytics-basiert, abgekündigt).

## Leitfragen
1. Warum scheitert `Get-ChildItem \\EXA-SRV03\Share` in einer Remote-Sitzung von EXA-CL01 auf EXA-SRV01?
2. Welche zwei Dateien braucht JEA, und welche enthält die erlaubten Cmdlets?
3. Was ändert sich für EXA-SRV01, wenn er Arc-fähig wird – und was nicht?

## Glossar
[[Azure Arc]] · [[JEA]] · [[Double-Hop]] · [[Windows Admin Center]] · [[Hybrid Runbook Worker]]
