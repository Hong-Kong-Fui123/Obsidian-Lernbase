---
aliases: [Speicher AZ-802, Storage AZ-802]
tags: [az-802, az-802/speicher, thema]
bereich: 05
gewicht: 15–20 %
status: offen
---
# 05 Speicher- und Dateidienste (15–20 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 05 Speicher - Aufgaben]]

## Prüfungsziele
**Azure Files:** Freigaben · Berechtigungen · Azure File Sync · Überwachung · DFS → File Sync · Migration
**Dateifreigaben:** Zugriff · FSRM · DFS · SMB über QUIC · SMB-Einstellungen
**Speicher:** Datenträger/Volumes · Speicherplätze · S2D · Speicherreplikat · Deduplizierung · SMB Direct · Storage QoS · NTFS/ReFS · iSCSI · BitLocker · verschlüsselte Volumes wiederherstellen

## Azure Files
| Thema | Merkpunkt |
|---|---|
| Protokolle | SMB 3.x (Port **445** ausgehend!), NFS (Premium) |
| Stufen | Premium (FileStorage), Transaktionsoptimiert, Hot, Cool |
| Identität | Share-Ebene: Azure-RBAC (*Storage File Data SMB Share Reader/Contributor/Elevated Contributor*); Datei-Ebene: NTFS-ACLs |
| Auth-Quellen | AD DS (Storage-Konto als Computerobjekt, `Join-AzStorageAccount`), Entra Domain Services, Entra Kerberos |
| Standard-Share-Berechtigung | für alle authentifizierten Identitäten setzbar |
| Snapshots / Soft Delete | Wiederherstellung |

### Azure File Sync
- Komponenten: **Speichersynchronisierungsdienst** → **Synchronisierungsgruppe** → **Cloudendpunkt** (1 Azure-Freigabe) + **Serverendpunkte** (Pfade auf registrierten Servern).
- Agent auf Server installieren + registrieren.
- **Cloud-Tiering**: Volume-Freiraum-% und Datumsrichtlinie; selten genutzte Dateien nur als Stub lokal.
- Überwachung: Azure Monitor-Metriken, Ereignisprotokoll *Microsoft-FileSync-Agent/Telemetry*, `Invoke-StorageSyncFileRecall`.
- **DFS-R → File Sync**: DFS-R-Replikation pro Ordner beenden, ein Server als Erstquelle, andere als neue Serverendpunkte; DFS-N kann bleiben.
- Migrationswege: Storage Mover, Robocopy, AzCopy, Data Box (offline).

## Windows-Dateifreigaben
- Effektiver Zugriff = restriktivste Kombination aus **Freigabe- und NTFS**-Berechtigung (über Netzwerk).
- Zugriffsbasierte Aufzählung (ABE), Offline-Dateien/Caching, kontinuierliche Verfügbarkeit (Cluster).
- `New-SmbShare`, `Grant-SmbShareAccess`, `Get-SmbShareAccess`.

### FSRM
| Funktion | Zweck |
|---|---|
| Kontingente | hart/weich, Vorlagen, Auto-Kontingent |
| Dateiprüfung | Dateigruppen blockieren (aktiv/passiv) |
| Speicherberichte | Duplikate, große Dateien … |
| Klassifizierung | Eigenschaften, Regeln (DAC-Basis) |
| Dateiverwaltungsaufgaben | Ablauf, Verschieben |

### DFS
- **DFS-N**: Namespace domänenbasiert (`\\example.com\Daten`) oder eigenständig; Ordnerziele, Referrals nach Standort.
- **DFS-R**: Multi-Master, Remote Differential Compression (RDC), Staging-Ordner, Replikationsgruppe, schreibgeschützte Replikate.

### SMB
| Thema | Merkpunkt |
|---|---|
| SMB 1 | deaktivieren/entfernen |
| Signierung | ab Server 2025 / Win11 24H2 standardmäßig erforderlich |
| Verschlüsselung | pro Freigabe oder Server (`Set-SmbServerConfiguration -EncryptData`) |
| SMB über QUIC | UDP **443**, TLS 1.3, Zertifikat nötig, „SMB-VPN“ für mobile Clients; Server 2025 alle Editionen; Client-Zugriffssteuerung |
| SMB Direct | RDMA-NICs (iWARP, RoCE, InfiniBand), geringe CPU-Last |
| SMB Multichannel | mehrere NICs automatisch |

## Windows-Server-Speicher
### Datenträger/Volumes
MBR (max. 2 TB, 4 primäre) vs. **GPT**; Basis- vs. dynamische Datenträger (veraltet → Speicherplätze). `Initialize-Disk`, `New-Partition`, `Format-Volume`.

### Speicherplätze (Storage Spaces)
Pool → virtueller Datenträger → Volume.
| Resilienz | Mind. Datenträger | Toleriert |
|---|---|---|
| Einfach | 1 | 0 |
| Zwei-Wege-Spiegel | 2 | 1 |
| Drei-Wege-Spiegel | 5 | 2 |
| Parität | 3 | 1 |
| Duale Parität | 7 | 2 |
Bereitstellung fest/schlank, Tiering (SSD/HDD), Hot Spare.

### Direkte Speicherplätze (S2D)
Cluster mit **lokalen** Laufwerken, Datacenter-Edition, 2–16 Knoten, Cache auf schnellsten Laufwerken, CSV + ReFS, Netzwerk ≥ 10 GbE (RDMA empfohlen), 2-Knoten → Zeuge (Cloud/Datei). `Enable-ClusterStorageSpacesDirect`.

### Speicherreplikat
Blockbasiert, **synchron** (RPO 0, Latenz ≤ 5 ms) oder **asynchron**. Szenarien: Server-zu-Server, Cluster-zu-Cluster, Stretch-Cluster. Daten- + **Protokoll-Volume** gleicher Größe. `Test-SRTopology`, `New-SRPartnership`. Standard-Edition eingeschränkt.

### Deduplizierung
Typen: Allgemeiner Dateiserver, VDI, Sicherung. Nicht für Systemvolume. ReFS unterstützt ab 2019. `Enable-DedupVolume`, `Start-DedupJob`.

### Storage QoS
Richtlinien min./max. IOPS für VHDX (CSV/SOFS): **Dediziert** (pro VHD) oder **Aggregiert** (gemeinsam).

### NTFS vs. ReFS
| | NTFS | ReFS |
|---|---|---|
| Boot-Volume | ja | nein |
| EFS, Kontingente (Datenträger), Komprimierung | ja | nein |
| Integritätsstreams, Block-Cloning | nein | ja |
| Empfohlen für | allgemein | S2D, Hyper-V, Backup |

### iSCSI
Target (Server, `.vhdx`-LUN) ↔ Initiator (Client, IQN). Port **3260**. CHAP, MPIO, iSNS. → Home-Lab EXA-SRV03.

### BitLocker
- TPM (+PIN), Wiederherstellungsschlüssel in **AD DS** sichern (GPO), Netzwerkentsperrung (Server), Cluster-CSV.
- Feature: `Install-WindowsFeature BitLocker`. Recovery: `manage-bde -protectors -get C:`, Schlüssel im AD sichtbar mit *BitLocker Recovery Password Viewer*.
- Wiederherstellung: `manage-bde -unlock D: -RecoveryPassword ...`, `repair-bde` bei Beschädigung.

## Prüfungsfallen
- Azure Files über Internet scheitert oft an **ISP-Sperre Port 445** → VPN/ExpressRoute/SMB über QUIC.
- Pro Synchronisierungsgruppe nur **ein** Cloudendpunkt.
- Cloud-Tiering nicht auf Systemvolume.
- Drei-Wege-Spiegel braucht 5 Datenträger (Speicherplätze), 3 Knoten (S2D).
- Speicherreplikat: Protokoll-Volume nicht vergessen.

## Leitfragen
1. Benutzer hat Freigabe *Vollzugriff*, NTFS *Lesen*. Effektiv?
2. Warum Cloud-Tiering für Außenstelle mit kleiner Platte?
3. Wann SMB über QUIC statt VPN?

## Glossar
[[Azure File Sync]] · [[Cloud-Tiering]] · [[FSRM]] · [[DFS]] · [[SMB über QUIC]] · [[S2D]] · [[Speicherreplikat]] · [[ReFS]] · [[iSCSI]] · [[BitLocker]]
