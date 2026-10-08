---
typ: wissen
thema: Windows Server
tags: [windows-server, speicher, storage-replica, hochverfuegbarkeit]
aliases: [Speicherreplikat, SR, Test-SRTopology]
erstellt: 2026-10-07
status: lernen
---
# Storage Replica (Speicherreplikat, SR)

Thema: [[Windows Server]] · Verwandt: [[Speicherpools]] · [[SMB]] · Glossar: [[SR]]
Lab: [[Lab Storage Replica Test-SRTopology]] · Vorlage: [[Vorlage Speicher-Lab]]

> [!warning] Begriff
> `Test-SRTopology` gehört zu **Storage Replica** (SR = Speicherreplikat).
> **Nicht** verwechseln mit dem *Startup Repair Tool* (Starthilfe/Systemstartreparatur in WinRE) – das repariert den Windows-Start, nicht Speicher.

## Was ist das?
- **Blockbasierte** Replikation ganzer Volumes zwischen Servern/Clustern (nicht dateibasiert wie [[DFSR]])
- Ziel: **Notfallwiederherstellung** – fällt die Quelle aus, liegen die Daten fertig auf dem Ziel
- Transport: [[SMB]] 3

| Modus | Verhalten | Datenverlust |
|---|---|---|
| **Synchron** (Standard) | Schreiben erst bestätigt, wenn auch Ziel-Log geschrieben | keiner (RPO = 0) |
| **Asynchron** | Quelle bestätigt sofort, Ziel folgt | wenige Sekunden möglich |

**Szenarien:** Server-zu-Server · Cluster-zu-Cluster · Stretched-Cluster

## Voraussetzungen
| Punkt | Anforderung |
|---|---|
| Edition | Datacenter (Standard ab 2019: 1 Partnerschaft, 1 Volume, max. 2 TB) |
| Domäne | alle Server in einer [[AD|AD-Domäne]] |
| Volumes je Server | **2**: Daten + **Log** (Log mind. 9 GB, möglichst SSD) |
| Größe | Daten-Volumes beider Server **gleich groß**, Log-Volumes ebenfalls |
| Partitionsstil | GPT, nicht auf dem Systemdatenträger |
| Firewall | [[ICMP]], [[SMB]] 445 (5445 SMB Direct), WS-MAN 5985 |
| Netzwerk | ca. 5 ms Roundtrip für synchron |

## Ablauf
**Maschine: Quell- und Zielserver** (PowerShell als Admin)
```powershell
Install-WindowsFeature Storage-Replica, FS-FileServer -IncludeManagementTools -Restart
```

**Maschine: Quellserver** – 1. Testen (erzeugt HTML-Bericht)
```powershell
Test-SRTopology -SourceComputerName exa-srv05 -SourceVolumeName D: -SourceLogVolumeName E: `
  -DestinationComputerName exa-srv01 -DestinationVolumeName D: -DestinationLogVolumeName E: `
  -ResultPath C:\temp -DurationInMinutes 2
```
> [!tip] Aussagekräftig wird der Leistungstest nur, wenn die Quelle während des Tests **Last** hat (Dateien kopieren).

**Maschine: Quellserver** – 2. Partnerschaft anlegen
```powershell
New-SRPartnership -SourceComputerName exa-srv05 -SourceRGName rg01 -SourceVolumeName D: -SourceLogVolumeName E: `
  -DestinationComputerName exa-srv01 -DestinationRGName rg02 -DestinationVolumeName D: -DestinationLogVolumeName E:
```

**Maschine: Quell- oder Zielserver** – 3. Überwachen
```powershell
Get-SRPartnership
(Get-SRGroup).Replicas | Select-Object DataVolume, ReplicationStatus, NumOfBytesRemaining
Get-WinEvent -ProviderName Microsoft-Windows-StorageReplica -MaxEvents 20
```
Wichtige Ereignis-IDs: 5015, 5002, 5004, 1237, 5001, 2200

**Maschine: Zielserver** – 4. Umschalten (Failover: Ziel wird Quelle)
```powershell
Set-SRPartnership -NewSourceComputerName exa-srv01 -SourceRGName rg02 `
  -DestinationComputerName exa-srv05 -DestinationRGName rg01
```

> [!warning] Echter Ausfall
> Quelle nicht erreichbar → auf dem Ziel `-Force` anhängen.

**Maschine: ursprüngliche Quelle** – Zurückschalten: gleicher Befehl mit vertauschten Namen
```powershell
Set-SRPartnership -NewSourceComputerName exa-srv05 -SourceRGName rg01 `
  -DestinationComputerName exa-srv01 -DestinationRGName rg02
```

**Optionen bei New-SRPartnership:** `-ReplicationMode Asynchronous` (entfernter Standort) · `-LogSizeInBytes 1GB` (Lab mit kleinem E:)

**Maschine: Quellserver** – 5. Entfernen
```powershell
Get-SRPartnership | Remove-SRPartnership
Get-SRGroup | Remove-SRGroup        # auf beiden Servern
```

> [!note] Ziel-Volume
> Während der Replikation ist D: auf dem Ziel **nicht zugreifbar** (ausgehängt). Erst nach dem Umschalten nutzbar.

> [!question] Selbsttest
> 1. Warum braucht SR ein eigenes Log-Volume?
> 2. Was ist der Unterschied zu [[DFSR]] bei geöffneten Dateien?
> 3. Synchron oder asynchron für einen Standort 300 km entfernt – und warum?

## 📄 Unterlagen
- Anleitung: [[Anleitung_Storage_Replica.pdf|Schritt-für-Schritt (PDF, 4 S.)]]
- Buch 70-740: [[70-740_Server2016_Installation_Speicher.pdf#page=182|Nutzungsszenarien]] · [[70-740_Server2016_Installation_Speicher.pdf#page=185|Implementierung, Voraussetzungen]] · [[70-740_Server2016_Installation_Speicher.pdf#page=186|Test-SRTopology]] · [[70-740_Server2016_Installation_Speicher.pdf#page=188|New-SRPartnership, Ereignisse]]
- [Microsoft Learn – Storage Replica Server-zu-Server](https://learn.microsoft.com/de-de/windows-server/storage/storage-replica/server-to-server-storage-replication)
