---
typ: wissen
thema: AZ-802
tags: [az-802, monitoring, troubleshooting, ad-ds, azure-monitor, exam]
aliases: [AZ-802 Bereich 7, AZ-802 Troubleshooting, AD wiederherstellen]
gewicht: "15–20 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 7 – Überwachen und Problembehandlung (15–20 %)

Kapitel: [[AZ-802 Übersicht]] · Zurück: [[AZ-802 6 Sicherheit]]
Vorwissen: [[Fehlerlog Home-Lab]] · [[Netzwerk und DNS Befehle]] · [[AD DS Überblick]]

## Prüfungsziele (Checkliste)
**Überwachen**
- [ ] Leistungsüberwachung (PerfMon) und [[Datensammlersatz|Datensammlersätze]]
- [ ] Überwachung und Warnungen in [[Windows Admin Center]]
- [ ] [[System Insights]]
- [ ] Ereignisprotokolle verwalten
- [ ] Datensammlungsregeln ([[DCR]]) für [[Azure Monitor]]
- [ ] Warnungen erstellen
- [ ] [[VM Insights]]

**Windows Server**
- [ ] Konnektivität · Namensauflösung · Windows Update · Zeitdienst · Leistung
- [ ] VM- und Azure-Arc-Erweiterungen
- [ ] Datenträgerverschlüsselung · Speicher

**Active Directory**
- [ ] Objekte aus dem [[AD-Papierkorb]] wiederherstellen
- [ ] AD-Datenbank im [[DSRM]] wiederherstellen
- [ ] SYSVOL wiederherstellen
- [ ] Replikation, Kerberos, [[Sicherer Kanal]]

## 1. Lokal überwachen
| Werkzeug | Zweck | Kernpunkt |
|---|---|---|
| Leistungsüberwachung | Echtzeit-Leistungsindikatoren | Prozessor % > 85 dauerhaft, Arbeitsspeicher *Verfügbare MB*, Datenträger *Mittlere Warteschlangenlänge* / *Sek./Übertragung* (> 20 ms), Netzwerk *Bytes gesamt/s* |
| [[Datensammlersatz]] | Indikatoren/Ablaufverfolgungen über Zeit aufzeichnen, Leistungswarnungen | Vorlage *System Performance*, Bericht unter *Berichte* |
| Ressourcenmonitor | wer belegt CPU/Datei/Port gerade | `resmon` |
| Ereignisanzeige | Protokolle, benutzerdefinierte Ansichten, **Ereignisabonnements** (Weiterleitung an Sammelserver) | `wecutil qc` auf dem Sammler, WinRM auf Quellen |
| WAC | Dashboards, **Warnungen**, Leistungsmonitor im Browser | auch über Arc im Azure-Portal |
| [[System Insights]] | lokale **Vorhersage** (Machine Learning): CPU, Netzwerk, Speicherverbrauch, Volumekapazität | `Get-InsightsCapability` |

```powershell
# Maschine: EXA-SRV01
Get-Counter '\Processor(_Total)\% Processor Time','\Memory\Available MBytes' -SampleInterval 5 -MaxSamples 6
logman create counter Basis -c '\Processor(_Total)\% Processor Time' '\Memory\Available MBytes' -si 00:00:15 -o C:\PerfLogs\Basis
logman start Basis
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object LevelDisplayName -eq 'Fehler'
Add-WindowsFeature System-Insights -IncludeManagementTools
Get-InsightsCapability; Invoke-InsightsCapability -Name 'Volume consumption forecasting'
```

## 2. Azure Monitor
| Baustein | Bedeutung |
|---|---|
| [[AMA]] (Azure Monitor Agent) | sammelt Daten auf Azure-VM / Arc-Server; ersetzt den alten Log-Analytics-Agent (MMA, eingestellt 08/2024) |
| [[DCR]] (Datensammlungsregel) | **was** gesammelt wird (Ereignisprotokolle mit XPath, Leistungsindikatoren) und **wohin** (Log Analytics) – einer Regel werden Server zugeordnet |
| [[Log Analytics]]-Arbeitsbereich | Datenspeicher, Abfrage mit [[KQL]] |
| Warnungen | **Metrik**-, **Protokoll**- (KQL), **Aktivitätsprotokoll**-Warnungen → **Aktionsgruppe** (Mail, SMS, Runbook, Webhook) |
| [[VM Insights]] | fertige Leistungsdiagramme + **Zuordnung** (Prozesse, Verbindungen; Dependency Agent) für Azure-VMs und Arc-Server |

```kusto
// Log Analytics – Fehler im Systemprotokoll der letzten 24 h je Server
Event
| where TimeGenerated > ago(24h) and EventLog == "System" and EventLevelName == "Error"
| summarize Anzahl = count() by Computer, Source
| order by Anzahl desc
```
```kusto
// CPU-Auslastung (VM Insights)
InsightsMetrics
| where Namespace == "Processor" and Name == "UtilizationPercentage"
| summarize avg(Val) by bin(TimeGenerated, 15m), Computer
```

## 3. Windows Server – Probleme beheben
| Bereich | Werkzeuge / Vorgehen |
|---|---|
| Konnektivität | `Test-NetConnection -Port`, `tracert`, `Get-NetIPConfiguration`, Firewall-Protokoll, NSG/IP-Fluss in Azure |
| Namensauflösung | `Resolve-DnsName -Server`, `ipconfig /flushdns`, `Clear-DnsServerCache`, `nslookup -debug`, Weiterleitungen |
| Windows Update | `Get-WindowsUpdateLog`, `C:\Windows\SoftwareDistribution` zurücksetzen, `DISM /Online /Cleanup-Image /RestoreHealth`, `sfc /scannow`, Update Manager-Bewertung |
| Zeitdienst | `w32tm /query /status`, `w32tm /query /source`, `w32tm /resync`; PDC-Emulator der Stammdomäne → externe Quelle; Azure-VMs: Hyper-V-Zeitsync |
| Leistung | Ressourcenmonitor, Datensammlersatz, Engpass finden (CPU/RAM/Datenträger/Netz) |
| VM-/Arc-Erweiterungen | Status im Portal, `azcmagent show`/`check`, Protokolle unter `C:\ProgramData\AzureConnectedMachineAgent\Log`; Azure-VM: `C:\WindowsAzure\Logs` |
| Datenträgerverschlüsselung | `manage-bde -status`, Wiederherstellungskennwort aus AD/Key Vault, TPM-Status `Get-Tpm` |
| Speicher | `Get-PhysicalDisk`/`Get-VirtualDisk` (HealthStatus), `Repair-VirtualDisk`, `chkdsk`, Ereignisse *Disk*/*Ntfs* |

```powershell
# Maschine: EXA-DC01 (PDC-Emulator) – externe Zeitquelle
w32tm /config /manualpeerlist:"de.pool.ntp.org,0x8" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time; w32tm /query /status
```

## 4. Active Directory – Probleme beheben
### AD-Papierkorb
- Einmal pro Gesamtstruktur aktivieren (Funktionsebene ≥ 2008 R2), **nicht rückgängig**.
- Gelöschte Objekte behalten **alle Attribute** (inkl. Gruppenmitgliedschaften) bis zum Ablauf (Standard 180 Tage).
```powershell
# Maschine: EXA-DC01
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target example.com
Get-ADObject -Filter 'isDeleted -eq $true -and Name -like "*Meier*"' -IncludeDeletedObjects
Get-ADObject -Filter 'samAccountName -eq "hmeier"' -IncludeDeletedObjects | Restore-ADObject
```

### DSRM und Wiederherstellung der AD-Datenbank
| Art | Wann | Ablauf |
|---|---|---|
| **Nicht autoritativ** | DC kaputt, andere DCs gesund | Systemstatus zurücksichern → DC holt neuere Änderungen per Replikation |
| **Autoritativ** | versehentlich gelöschte Objekte **ohne** Papierkorb | Systemstatus zurücksichern → im DSRM mit `ntdsutil` Objekte autoritativ markieren → Neustart |
```powershell
# Maschine: EXA-DC01 – in den DSRM starten
bcdedit /set safeboot dsrepair; Restart-Computer
# im DSRM (Anmeldung .\Administrator mit DSRM-Kennwort):
wbadmin get versions
wbadmin start systemstaterecovery -version:10/19/2026-12:00
ntdsutil "activate instance ntds" "authoritative restore" "restore subtree ""OU=Vertrieb,DC=example,DC=com""" quit quit
bcdedit /deletevalue safeboot; Restart-Computer
```

### SYSVOL wiederherstellen (DFSR)
- **Nicht autoritativ** (ein DC hat kaputtes SYSVOL): am betroffenen DC `msDFSR-Enabled=FALSE` setzen, replizieren, wieder `TRUE` → holt SYSVOL von Partnern.
- **Autoritativ** (SYSVOL überall kaputt): auf **einem** DC `msDFSR-Options=1` + alle DCs deaktivieren/aktivieren → dieser DC ist die Quelle.
- Attribute im Objekt `CN=SYSVOL Subscription,CN=Domain System Volume,CN=DFSR-LocalSettings,CN=<DC>,OU=Domain Controllers,…` (ADSI-Edit), danach `dfsrdiag pollad`.

### Replikation, Kerberos, sicherer Kanal
| Problem | Werkzeug |
|---|---|
| Replikation | `repadmin /replsummary`, `repadmin /showrepl`, `repadmin /syncall /AdeP`, `dcdiag /v /c`, Ereignisprotokoll *Directory Service* |
| Kerberos | Uhrzeit (max. 5 Min.), SPNs doppelt? `setspn -X`, Tickets `klist`, Ereignis 4771/4768 |
| Sicherer Kanal | `Test-ComputerSecureChannel -Repair -Credential EXAMPLE\Administrator`, `nltest /sc_verify:example.com`; Symptom „Vertrauensstellung zwischen Arbeitsstation und Domäne fehlgeschlagen“ |

```powershell
# Maschine: EXA-DC01
dcdiag /v /c /e /f:C:\Temp\dcdiag.txt
repadmin /replsummary
repadmin /showrepl EXA-DC02
# Maschine: betroffener Server
Test-ComputerSecureChannel -Verbose
```

## Fallen
- Papierkorb erst **nach** dem Löschen aktivieren nützt nichts für bereits gelöschte Objekte.
- Autoritative Wiederherstellung ohne `ntdsutil`-Markierung → Objekte werden von den Partnern wieder gelöscht.
- DSRM-Anmeldung mit dem **lokalen** DSRM-Kennwort, nicht mit Domänenkonto.
- Neue Server-Überwachung: AMA + DCR – nicht mehr MMA/„Log Analytics Agent“.

## Glossar
[[Datensammlersatz]] · [[System Insights]] · [[Windows Admin Center]] · [[Azure Monitor]] · [[AMA]] · [[DCR]] · [[Log Analytics]] · [[KQL]] · [[VM Insights]] · [[AD-Papierkorb]] · [[DSRM]] · [[repadmin]] · [[dcdiag]] · [[W32Time]] · [[Sicherer Kanal]] · [[DFSR]]
