---
typ: lab
thema: Windows Server
tags: [lab, speicher, storage-replica]
datum: 2026-10-07
ort: Schule
status: in-arbeit
ergebnis:
---
# Lab Storage Replica – Test-SRTopology und Partnerschaft

Thema: [[Windows Server]] · Theorie: [[Storage Replica]] · [[Speicherpools]] · Lab: [[VM-Infrastruktur]] · Fehler: [[Fehlerlog Home-Lab]]

## 🎯 Ziel
Speicherwiederherstellung vorbereiten: Volume D: eines Servers blockweise auf einen zweiten Server replizieren. Zuerst prüfen, ob die Umgebung geeignet ist (`Test-SRTopology`).

## 🖥️ Aufbau
| Maschine | Rolle | Datenträger |
|---|---|---|
| EXA-DC01 | Domänencontroller (example.com) | – |
| EXA-SRV01 | **Ziel** (Destination) | D: Daten · E: Log |
| EXA-SRV05 | **Quelle** (Source) | D: Daten · E: Log |

> [!question] Klären
> Im Aufbau hast du **SRV04** notiert, im Befehl steht **exa-Srv05** als Quelle. Welcher Server war es? → Tabelle anpassen.

## 🔧 Durchführung
**Vorbereitung – Maschine: EXA-SRV01 und EXA-SRV05**
```powershell
Install-WindowsFeature Storage-Replica, FS-FileServer -IncludeManagementTools -Restart
Get-Volume -DriveLetter D,E          # gleiche Größe auf beiden Servern?
```

**Test – Maschine: Quellserver (Prompt `EXAMPLE>`)**
```powershell
Test-SRTopology -SourceComputerName exa-Srv05 -SourceVolumeName D: -SourceLogVolumeName E: `
  -DestinationComputerName exa-srv01 -DestinationVolumeName D: -DestinationLogVolumeName E: `
  -ResultPath c:\temp -DurationInMinutes 2
```
Bericht: `C:\temp\TestSrTopologyReport-<Datum>.html`

**Partnerschaft anlegen – Maschine: Quellserver EXA-SRV05**
```powershell
New-SRPartnership -SourceComputerName exa-srv05 -SourceRGName mySRrep -SourceVolumeName D: -SourceLogVolumeName E: `
  -DestinationComputerName exa-srv01 -DestinationRGName mySRrep -DestinationVolumeName D: -DestinationLogVolumeName E:
```
> [!note] Gruppennamen
> Quelle und Ziel heißen beide `mySRrep`. Das ist möglich, weil jede Replikationsgruppe zu ihrem eigenen Server gehört. Übersichtlicher sind aber verschiedene Namen (z. B. `rg-srv05`, `rg-srv01`), sonst verwechselt man sie beim Umschalten leicht.

**Prüfen – Maschine: EXA-SRV05 oder EXA-SRV01**
```powershell
Get-SRPartnership
(Get-SRGroup).Replicas | Select-Object DataVolume, ReplicationStatus, NumOfBytesRemaining
Get-WinEvent -ProviderName Microsoft-Windows-StorageReplica -MaxEvents 20 | Format-Table TimeCreated, Id, Message -Wrap
```
Erwartet: `ReplicationStatus` = **ContinuouslyReplicating**, `NumOfBytesRemaining` = 0. Auf EXA-SRV01 ist D: jetzt **nicht** mehr zugreifbar.

## 📊 Ergebnis
| Prüfung | Ergebnis | Bemerkung |
|---|---|---|
| Voraussetzungen (Edition, Domäne, Volumes) | ☐ ok ☐ Fehler | |
| Netzwerk/Firewall | ☐ ok ☐ Fehler | |
| Durchsatz synchron ausreichend | ☐ ja ☐ nein | |
| Partnerschaft angelegt (`New-SRPartnership`) | ☐ ok ☐ Fehler | |
| Erstsynchronisierung fertig (Bytes = 0) | ☐ ja ☐ nein | |

## ⚠️ Fehler / Beobachtungen
-

## ➡️ Nächster Schritt
1. ~~Partnerschaft anlegen~~ ✅ erledigt
2. Failover testen – **Maschine: EXA-SRV01**:
```powershell
Set-SRPartnership -NewSourceComputerName exa-srv01 -SourceRGName mySRrep `
  -DestinationComputerName exa-srv05 -DestinationRGName mySRrep
Get-Volume -DriveLetter D      # D: auf EXA-SRV01 jetzt lesbar?
```
3. Aufräumen – **Maschine: aktuelle Quelle**: `Get-SRPartnership | Remove-SRPartnership`, danach auf **beiden** Servern `Get-SRGroup | Remove-SRGroup`
→ Theorie: [[Storage Replica#Ablauf|Ablauf]]

## 📄 Unterlagen
- [[70-740_Server2016_Installation_Speicher.pdf#page=186|70-740: Test-SRTopology]] · [[70-740_Server2016_Installation_Speicher.pdf#page=188|New-SRPartnership]]
