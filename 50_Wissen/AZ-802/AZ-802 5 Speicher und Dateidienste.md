---
typ: wissen
thema: AZ-802
tags: [az-802, speicher, azure-files, file-sync, smb, exam]
aliases: [AZ-802 Bereich 5, AZ-802 Speicher, Azure Files und File Sync]
gewicht: "15–20 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 5 – Speicher und Dateidienste (15–20 %)

Kapitel: [[AZ-802 Übersicht]] · Zurück: [[AZ-802 4 Netzwerk DNS DHCP]] · Weiter: [[AZ-802 6 Sicherheit]]
Vorwissen: [[Speicherpools]] · [[Storage Replica]] · [[Hochverfügbarer Dateiserver]] · [[Lab Failovercluster Dateiserver]] · [[50_Wissen/Windows Server/VHD-und-VHDX|VHD-und-VHDX]] · [[TRIM-und-UNMAP]]

## Prüfungsziele (Checkliste)
**Azure Files**
- [ ] Azure-Dateifreigaben erstellen und Berechtigungen verwalten → [[Azure Files]]
- [ ] [[Azure File Sync]] konfigurieren, überwachen
- [ ] DFS-Replikation → Azure File Sync migrieren
- [ ] Dateifreigaben → Azure Files migrieren

**Windows-Server-Freigaben**
- [ ] Zugriff auf Freigaben (Freigabe- + NTFS-Rechte, [[ABE]])
- [ ] FSRM (Kontingente, Dateiprüfung, Klassifizierung)
- [ ] [[DFS]] (Namespace + Replikation)
- [ ] [[SMB over QUIC]]
- [ ] SMB-Einstellungen

**Windows-Server-Speicher**
- [ ] Datenträger und Volumes (MBR/GPT) → [[50_Wissen/Windows Server/VHD-und-VHDX|VHD-und-VHDX]]
- [ ] Storage Spaces → [[Speicherpools]] · Storage Spaces Direct
- [ ] [[Storage Replica]]
- [ ] [[Deduplizierung]]
- [ ] [[SMB Direct]] ([[RDMA]])
- [ ] [[Storage QoS]]
- [ ] Dateisysteme [[NTFS]] und [[ReFS]]
- [ ] [[iSCSI]] → [[Lab Failovercluster Dateiserver]]
- [ ] [[BitLocker]] verwalten, verschlüsselte Volumes wiederherstellen

## 1. Azure Files
| Thema | Kernpunkt |
|---|---|
| Was | Dateifreigabe als Dienst in einem **Speicherkonto**; Zugriff per **SMB 3.x (TCP 445)** oder NFS (Premium) |
| Stufen | Premium (SSD, Konto-Typ *FileStorage*) · Transaktionsoptimiert · Heiß · Kalt |
| Redundanz | LRS · ZRS · GRS · GZRS |
| Schutz | Freigabe-Momentaufnahmen, vorläufiges Löschen (Soft Delete), Azure Backup |
| Port 445 | wird von vielen Providern ausgehend **blockiert** → VPN/ExpressRoute, Private Endpoint oder File Sync nutzen |

### Berechtigungen (zwei Ebenen wie lokal)
| Ebene | Wie |
|---|---|
| **Freigabe** | Azure-RBAC: *Storage File Data SMB Share Reader / Contributor / Elevated Contributor* (oder Standardberechtigung für alle authentifizierten Identitäten) |
| **Verzeichnis/Datei** | ganz normale **NTFS-ACLs** (icacls / Explorer) |
| Identitätsquelle | lokales **AD DS** (Speicherkonto wird Computerkonto im AD), **Entra Kerberos** (hybride Identitäten, ohne DC-Sicht) oder Entra Domain Services |
| Notzugriff | Speicherkontoschlüssel (wie Superuser – nur für Administration) |
```powershell
# Maschine: EXA-SRV01 (domänenverbunden, Modul AzFilesHybrid) – Speicherkonto im AD registrieren
Connect-AzAccount
Join-AzStorageAccount -ResourceGroupName rg-az802-lab -StorageAccountName saaz802lab `
  -DomainAccountType ComputerAccount -OrganizationalUnitDistinguishedName 'OU=Azure,DC=example,DC=com'
# Freigabe verbinden
net use Z: \\saaz802lab.file.core.windows.net\daten
```

## 2. Azure File Sync
Macht einen Windows-Dateiserver zum **Cache** einer Azure-Dateifreigabe.
| Baustein | Bedeutung |
|---|---|
| Speichersynchronisierungsdienst | Azure-Ressource, Klammer um alles |
| Synchronisierungsgruppe | **ein** Cloudendpunkt + beliebig viele Serverendpunkte |
| Cloudendpunkt | die Azure-Dateifreigabe |
| Registrierter Server | Windows Server mit **File-Sync-Agent** (ausgehend HTTPS 443) |
| Serverendpunkt | Pfad auf dem Server (z. B. `D:\Daten`), **nicht** auf dem Systemvolume, wenn Cloud-Tiering aktiv |
| [[Cloud-Tiering]] | selten genutzte Dateien bleiben nur als Platzhalter lokal; Richtlinie **freier Volumespeicher** (%) und/oder **Datum** |

**Reihenfolge (Prüfung!):** Speicherkonto + Dateifreigabe → Speichersynchronisierungsdienst → Synchronisierungsgruppe (mit Cloudendpunkt) → Agent installieren + Server registrieren → Serverendpunkt hinzufügen.
**Überwachen:** Portal (Synchronisierungsstatus, Dateien nicht synchronisiert), Azure Monitor-Metriken, Ereignisanzeige *Microsoft-FileSync-Agent/Telemetry*, `Invoke-StorageSyncFileRecall`.

### Migrationen
| Von → nach | Weg |
|---|---|
| DFS-R → Azure File Sync | Ein DFS-R-Mitglied als ersten Serverendpunkt einrichten, warten bis hochgeladen, dann weitere Server als Serverendpunkte; **DFS-R und File Sync nicht auf denselben Ordnern parallel** betreiben |
| Dateiserver → Azure Files | Robocopy (`/MIR /COPY:DATSO`), Azure Storage Mover, Azure File Sync als Brücke |
| Alter Dateiserver → neuer Server/Azure-VM | [[Storage Migration Service]] (WAC): Inventur → Übertragung → **Übernahme** von Name und IP |

## 3. Windows-Server-Freigaben
| Thema | Kernpunkt |
|---|---|
| Rechte | Freigabe- und NTFS-Recht → **strengeres** gewinnt; Empfehlung: Freigabe *Authentifizierte Benutzer: Ändern*, fein über NTFS |
| [[ABE]] | Benutzer sehen nur, worauf sie Zugriff haben |
| FSRM | **Kontingente** (hart/weich, Vorlagen), **Dateiprüfung** (aktiv/passiv, z. B. keine .mp4), Klassifizierung, Berichte |
| DFS-N | ein Pfad `\\example.com\daten` für viele Server; domänenbasiert oder eigenständig |
| DFS-R | Replikation zwischen Ordnern (Multimaster, RDC) |
| [[SMB over QUIC]] | SMB über **UDP 443** mit TLS 1.3 – Zugriff ohne VPN; Server 2025 in allen Editionen; Zertifikat nötig; Clientzugriffssteuerung |
| SMB-Einstellungen | SMB1 aus, Signatur (2025: ausgehend Pflicht), Verschlüsselung pro Freigabe oder Server, Komprimierung |
```powershell
# Maschine: EXA-SRV01
Install-WindowsFeature FS-Resource-Manager, FS-DFS-Namespace, FS-DFS-Replication -IncludeManagementTools
New-FsrmQuota -Path D:\Daten\Projekte -Size 5GB -Description 'Hartes Limit'
New-FsrmFileScreen -Path D:\Daten -IncludeGroup 'Audio and Video Files' -Active
Set-SmbServerConfiguration -EnableSMB1Protocol $false -EncryptData $true -Force
Get-SmbServerConfiguration | Format-List EnableSMB1Protocol, RequireSecuritySignature, EncryptData
```

## 4. Speicher auf Windows Server
| Technik | Kernpunkt |
|---|---|
| Storage Spaces | Pool aus Datenträgern → virtuelle Datenträger: **Einfach** (kein Schutz), **Spiegel** (2/3-fach), **Parität**; fest oder **schlank** (thin) → [[Speicherpools]] |
| Storage Spaces Direct (S2D) | Cluster aus **lokalen** Datenträgern (Datacenter), 2–16 Knoten, Cache auf schnellen Datenträgern, ReFS + [[CSV]]; Server 2025: Thin Provisioning, Campus-Cluster |
| [[Storage Replica]] | blockweise Replikation synchron/asynchron |
| [[Deduplizierung]] | doppelte Blöcke einmal speichern; Profile *Allgemeiner Dateiserver*, *Hyper-V (VDI)*, *Sicherung*; nicht auf Systemvolume |
| [[SMB Direct]] | SMB über RDMA-Karten |
| [[Storage QoS]] | IOPS-Minimum/-Maximum für VHDX auf **CSV/SoFS**; Richtlinien *Dediziert* (je VHD) oder *Aggregiert* (gemeinsam) |
| NTFS vs ReFS | ReFS: Integritätsströme, Block-Klonen (schnelle VHDX-Operationen), für S2D/Hyper-V; **kein** Booten, keine Kontingente/EFS/Komprimierung wie NTFS |
| [[iSCSI]] | Ziel + Initiator, MPIO für Redundanz |

```powershell
# Maschine: EXA-SRV01 – Deduplizierung
Install-WindowsFeature FS-Data-Deduplication
Enable-DedupVolume -Volume D: -UsageType Default
Start-DedupJob -Volume D: -Type Optimization; Get-DedupStatus
# Maschine: Clusterknoten – Storage QoS
New-StorageQosPolicy -Name Gold -PolicyType Dedicated -MinimumIops 500 -MaximumIops 2000
Get-VM EXA-WEB01 | Get-VMHardDiskDrive | Set-VMHardDiskDrive -QoSPolicyID (Get-StorageQosPolicy -Name Gold).PolicyId
```

## 5. BitLocker
| Thema | Kernpunkt |
|---|---|
| Schutzvorrichtungen | TPM, TPM+PIN, Wiederherstellungskennwort (48 Ziffern), Schlüsseldatei; Server: oft **Netzwerkentsperrung** |
| Wiederherstellung | Kennwort im AD sichern (GPO + `Backup-BitLockerKeyProtector`), Anzeige im ADUC-Reiter *BitLocker-Wiederherstellung* (Feature *RSAT-Feature-Tools-BitLocker*) |
| Datenvolumes | automatisch entsperren oder `Unlock-BitLocker` |
| Azure-VM | Azure Disk Encryption = BitLocker im Gast, Schlüssel im Key Vault |
```powershell
# Maschine: EXA-SRV01
Install-WindowsFeature BitLocker -IncludeAllSubFeature -IncludeManagementTools -Restart
Enable-BitLocker -MountPoint D: -RecoveryPasswordProtector
$kp = (Get-BitLockerVolume D:).KeyProtector | Where-Object KeyProtectorType -eq 'RecoveryPassword'
Backup-BitLockerKeyProtector -MountPoint D: -KeyProtectorId $kp.KeyProtectorId
manage-bde -status
Unlock-BitLocker -MountPoint D: -RecoveryPassword '111111-222222-...'   # Wiederherstellung
```

## Fallen
- File Sync: genau **ein** Cloudendpunkt je Synchronisierungsgruppe; Cloud-Tiering nicht auf dem Systemvolume.
- Azure-Files-Berechtigung braucht **beides**: RBAC auf Freigabe **und** NTFS.
- Fortlaufende Verfügbarkeit verträgt sich nicht mit FSRM-Kontingenten → [[Hochverfügbarer Dateiserver]].
- SMB over QUIC braucht ein Zertifikat, dem der Client vertraut → [[PKI und Zertifikatdienste]].

## Glossar
[[Azure Files]] · [[Azure File Sync]] · [[Cloud-Tiering]] · [[Storage Migration Service]] · [[ABE]] · [[DFS]] · [[DFSR]] · [[SMB over QUIC]] · [[SMB]] · [[SMB Direct]] · [[Storage QoS]] · [[Deduplizierung]] · [[NTFS]] · [[ReFS]] · [[iSCSI]] · [[BitLocker]] · [[CSV]]
