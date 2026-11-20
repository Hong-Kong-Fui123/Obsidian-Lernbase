---
aliases: [Monitoring AZ-802, Troubleshooting AZ-802, Überwachung AZ-802]
tags: [az-802, az-802/monitoring, thema]
bereich: 07
gewicht: 15–20 %
status: offen
---
# 07 Überwachen und Fehler beheben (15–20 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 07 Troubleshooting - Aufgaben]]

## Prüfungsziele
**Überwachen:** Leistungsmonitor · Datensammlersätze · WAC-Warnungen · Systemeinblicke · Ereignisprotokolle · Azure-Monitor-DCR · Warnungen · VM Insights
**Troubleshooting Server:** Verbindung · Namensauflösung · Windows Update · Zeitdienst · Leistung · VM-/Arc-Erweiterungen · Datenträgerverschlüsselung · Speicher
**Troubleshooting AD:** AD-Papierkorb · DSRM-Wiederherstellung · SYSVOL · Replikation · lokales AD · Kerberos · Secure Channel

## Überwachen lokal
| Werkzeug | Zweck |
|---|---|
| Leistungsmonitor | Echtzeit-Leistungsindikatoren |
| Datensammlersatz | Indikatoren/Trace/Konfiguration zeitgesteuert, Leistungswarnungen |
| Ressourcenmonitor | Prozess je Ressource |
| Systemeinblicke (System Insights) | lokale ML-Vorhersage: CPU, Netzwerk, Volume-Verbrauch, Gesamtspeicher |
| WAC | Dashboards, Warnungen über Azure Monitor |
| Ereignisanzeige | Abonnements (Collector `wecsvc`, Forwarder WinRM), benutzerdef. Ansichten |

### Wichtige Leistungsindikatoren (Richtwerte)
| Indikator | Problem bei |
|---|---|
| Processor\% Processor Time | > 85 % dauerhaft |
| System\Processor Queue Length | > 2 pro Kern |
| Memory\Available MBytes | < 10 % |
| Memory\Pages/sec | dauerhaft hoch |
| PhysicalDisk\Avg. Disk sec/Read | > 20 ms |
| PhysicalDisk\Avg. Disk Queue Length | > 2 pro Spindel |
| Network Interface\Bytes Total/sec | > 70 % Bandbreite |

## Überwachen Azure
- **Azure Monitor Agent (AMA)** + **Datensammlungsregel (DCR)**: Quellen (Perf, Ereignisse per XPath), Ziel Log Analytics. Ersetzt MMA/Log-Analytics-Agent (abgekündigt).
- Warnungen: Metrik-, Protokoll-(KQL-), Aktivitätsprotokollwarnung → **Aktionsgruppe** (Mail, SMS, Runbook, Webhook).
- **VM Insights**: Leistung + Map (Dependency Agent), DCR.

## Troubleshooting Server
| Problem | Werkzeuge |
|---|---|
| Verbindung | `Test-NetConnection -Port`, `tracert`, `pathping`, Firewall-Protokoll, NSG-Flow, Network Watcher |
| Namensauflösung | `Resolve-DnsName`, `nslookup`, `ipconfig /flushdns`, `Clear-DnsServerCache`, hosts-Datei, NRPT |
| Windows Update | `C:\Windows\Logs\WindowsUpdate` → `Get-WindowsUpdateLog`, Dienste wuauserv/BITS, `SoftwareDistribution` umbenennen, DISM `/RestoreHealth`, `sfc /scannow` |
| Zeitdienst | `w32tm /query /status`, `/resync`, `/monitor`; Kerberos-Toleranz **5 Min**; Hierarchie PDC-Root → extern |
| Leistung | Baseline, Perfmon, Ressourcenmonitor, WPR/WPA |
| VM/Arc-Erweiterung | `azcmagent check`, `azcmagent show`, Logs `C:\ProgramData\GuestConfig\ext_mgr_logs`, Erweiterung neu installieren |
| Verschlüsselung | `manage-bde -status`, Recovery-Schlüssel aus AD/Entra, `repair-bde` |
| Speicher | `chkdsk`, `Repair-Volume`, `Get-PhysicalDisk` (HealthStatus), `Get-StorageJob`, Speicherplätze reparieren |

## Troubleshooting AD
| Szenario | Lösung |
|---|---|
| Objekt gelöscht, Papierkorb aktiv | `Get-ADObject -IncludeDeletedObjects` → `Restore-ADObject`; Papierkorb einmal aktiviert = nicht deaktivierbar |
| Kein Papierkorb | autoritative Wiederherstellung: DSRM → Systemstatus-Backup (`wbadmin`) → `ntdsutil` *authoritative restore* |
| Ganze DB defekt | nicht-autoritativ aus Sicherung im DSRM |
| SYSVOL wiederherstellen | DFSR: autoritativ `msDFSR-Options=1` auf einem DC, nicht-autoritativ auf anderen (`msDFSR-Enabled`) |
| Replikation | `repadmin /replsummary`, `/showrepl`, `/syncall /AeD`, `dcdiag /test:replications`, Event 1311/2042 (Tombstone 180 Tage), USN-Rollback |
| Lokales AD | `dcdiag`, Dienst NTDS, DNS-SRV-Einträge, `nltest /dsgetdc:` |
| Kerberos | Zeit, SPN (`setspn -X` Duplikate), `klist purge`, Ereignis 4768/4771, Verschlüsselungstypen |
| Secure Channel | `Test-ComputerSecureChannel -Repair`, `Reset-ComputerMachinePassword`, `nltest /sc_verify:` |

## Prüfungsfallen
- Papierkorb-Wiederherstellung **ohne** Neustart/DSRM.
- Autoritativ = gewinnt bei Replikation (USN erhöht).
- Zeitabweichung > 5 Min → Kerberos-Fehler, nicht „falsches Kennwort“.
- MMA ist abgekündigt → **AMA + DCR**.

## Leitfragen
1. OU mit 50 Benutzern gelöscht, Papierkorb aus, letzte Sicherung gestern. Ablauf?
2. Client meldet „Vertrauensstellung zwischen Arbeitsstation und Domäne fehlgeschlagen“. Erster Befehl?
3. Welche zwei Azure-Objekte brauchst du minimal, um Ereignis-ID 4625 von EXA-SRV01 in Log Analytics zu sammeln?

## Glossar
[[Datensammlersatz]] · [[DCR]] · [[AD-Papierkorb]] · [[DSRM]] · [[Autoritative Wiederherstellung]] · [[Secure Channel]] · [[repadmin]]
