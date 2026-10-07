---
title: Übersicht Praxisklausuren
tags:
  - moc
  - klausur
  - homelab
---
# Übersicht Praxisklausuren

Drei Übungsklausuren für das Hyper-V-Homelab. Jede Klausur hat einen Praxisteil (nachbauen, einrichten, Fehler beheben) und einen kurzen Theorieteil.

| Klausur | Inhalt | Zeit |
|---|---|---|
| [[Praxisklausur 1 - AD DS DNS DHCP]] | Gesamtstruktur, zweiter [[DC]], OUs, CSV-Import, [[DHCP]], [[AGDLP]], Client, Fehlersuche | 200 min |
| [[Praxisklausur 2 - PKI Zertifikate]] | Offline-Root-CA, Issuing-CA, [[CDP]]/[[AIA]], Webserver-Zertifikat, Autoenrollment, Sperrung, Sicherung | 230 min |
| [[Praxisklausur 3 - Betrieb und Fehlerbehebung]] | [[FSMO]], Papierkorb, PSO, Delegierung, Vertrauensstellung, Kontosperrung, [[GPO]], [[DNS]] | 200 min |
| [[Vorbereitung - Fehler einbauen]] | Skripte für die Fehleraufgaben | - |

## Reihenfolge

1. Klausur 1 auf frischen VMs. Am Ende Prüfpunkt **K1-Ende** für alle VMs.
2. Klausur 2 und Klausur 3 starten jeweils von **K1-Ende**.
3. Vor jeder Klausur Prüfpunkt anlegen, damit sie wiederholt werden kann.

**Auf dem Hyper-V-Host** (PowerShell als Administrator):

```powershell
Get-VM EXA-* | Checkpoint-VM -SnapshotName "K1-Ende"
Get-VM EXA-* | ForEach-Object { Restore-VMCheckpoint -VMName $_.Name -Name "K1-Ende" -Confirm:$false }
```

## Lab-Plan

| [[VM]] | Rolle | [[IP]]-Adresse | OS |
|---|---|---|---|
| EXA-DC01 | Domänencontroller, DNS | 192.168.100.10/24 | Server 2022 |
| EXA-DC02 | Domänencontroller, DNS | 192.168.100.11/24 | Server 2022 |
| EXA-CA01 | Untergeordnete Enterprise-CA | 192.168.100.20/24 | Server 2022 |
| EXA-WEB01 | [[IIS]], [[PKI]]-Veröffentlichung | 192.168.100.30/24 | Server 2022 |
| EXA-DHCP01 | DHCP, Dateiserver | 192.168.100.50/24 | Server 2022 |
| EXA-ROOTCA (VM EXA-TEST01) | Offline-Stamm-CA, Arbeitsgruppe | 192.168.100.60/24 | Server 2022 |
| EXA-CL01 | Client | DHCP | Windows 11 |

- Domäne: **exa.local**, NetBIOS: **EXA**
- Hyper-V-Switch: **EXA-LAN** (intern oder privat), Netz 192.168.100.0/24
- Gateway 192.168.100.1 (nur eintragen, falls ein Router im Lab existiert)
- Netzwerkadapter heißt in den VMs **Ethernet** (prüfen mit `Get-NetAdapter`)

## Ergebnisse

```dataview
TABLE typ, status, ergebnis, datum
FROM #klausur AND #homelab AND -#moc AND -#vorbereitung
SORT file.name ASC
```

> [!tip] Ohne Dataview
> Die Tabelle braucht das Community-Plugin Dataview. Sonst in jeder Klausur die Eigenschaften status, ergebnis und datum pflegen.

## 📄 Passende Unterlagen
- Praxisklausur 1 (AD DS, DNS, DHCP): [[AD DS Überblick]] · [[DHCP-Server]] · [[Glossar/Forward-Lookup-Zone]] · [[DHCP_WindowsServer2025.pdf#page=11|Folien DHCP-Installation]]
- Praxisklausur 2 (PKI): [[PKI und Zertifikatdienste]] · [[Uebung_Zertifizierungsstellen_installieren.pdf|Schulübung CA]]
- Praxisklausur 3 (Betrieb/Fehler): [[AD-Gruppenrichtlinien.pdf#page=30|GPO-Problembehandlung]] · [[DHCP_WindowsServer2025.pdf#page=23|DHCP-Troubleshooting]]
- Theorie: [[00 Uebersicht Theorieklausuren]]
