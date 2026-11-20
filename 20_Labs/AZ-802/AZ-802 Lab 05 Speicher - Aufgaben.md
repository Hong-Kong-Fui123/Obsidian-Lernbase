---
tags: [az-802, lab, az-802/speicher]
bereich: 05
umgebung: HL + HY
maschinen: [Hyper-V-Host, EXA-SRV02, EXA-SRV03, EXA-CL01, EXA-DC01, Azure-Portal]
status: offen
---
# Lab 05 Speicher – Aufgaben
↑ [[AZ-802 05 Speicher und Dateidienste]] · Lösungen: [[AZ-802 Lab 05 Speicher - Loesungen]]

### A1 – Speicherplätze
**Maschinen:** Hyper-V-Host → EXA-SRV02
**Auftrag:** 5 × 10-GB-VHDX anhängen, Pool `Pool1`, Drei-Wege-Spiegel (thin) 15 GB, ReFS, Laufwerk `S:`.
**Leitfrage:** Wie viel Rohkapazität belegt ein 15-GB-Drei-Wege-Spiegel?
**Validierung (EXA-SRV02):** `Get-VirtualDisk | ft FriendlyName,ResiliencySettingName,NumberOfDataCopies,HealthStatus`

### A2 – iSCSI
**Maschinen:** EXA-SRV03 (Target), EXA-SRV02 (Initiator)
**Auftrag:** LUN 5 GB, Zugriff nur für IQN von EXA-SRV02, CHAP.
**Validierung (EXA-SRV02):** `Get-IscsiSession` · `Get-Disk | ? BusType -eq iSCSI`

### A3 – Deduplizierung + BitLocker
**Maschine:** EXA-SRV02
**Auftrag:** Dedup (Allgemeiner Dateiserver) auf `S:`. BitLocker auf iSCSI-Volume mit Kennwort-Protector, Wiederherstellungskennwort in AD sichern, Volume sperren und mit Wiederherstellungskennwort entsperren.
**Leitfrage:** Welche GPO-Einstellung erzwingt AD-Sicherung *vor* Verschlüsselung?
**Validierung:** `Get-DedupStatus` · `manage-bde -status` · EXA-DC01: `Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'}`

### A4 – Freigabe + FSRM
**Maschine:** EXA-SRV03
**Auftrag:** Freigabe `IT` (ABE an, `DL_Share_IT_RW` Ändern), Kontingent 2 GB hart, Dateiprüfung blockiert Audio/Video.
**Leitfrage:** Effektive Rechte bei Freigabe *Ändern* + NTFS *Vollzugriff*?
**Validierung (EXA-CL01):** `.mp3` nach `\\EXA-SRV03\IT` kopieren → verweigert.

### A5 – DFS-N + DFS-R
**Maschinen:** EXA-SRV02, EXA-SRV03
**Auftrag:** Domänennamespace `\\example.com\Daten`, Ordner `IT` mit Zielen auf beiden Servern, Replikationsgruppe.
**Validierung (EXA-SRV03):** `Get-DfsrBacklog -GroupName IT-RG -FolderName IT -SourceComputerName EXA-SRV02 -DestinationComputerName EXA-SRV03`

### A6 – SMB-Härtung + QUIC (Theorie + Teilpraxis)
**Maschine:** EXA-SRV03
**Auftrag:** SMB1 prüfen/entfernen, Verschlüsselung für Freigabe `IT`, Signierung erzwingen. SMB über QUIC: Zertifikat aus EXA-CA beschaffen und Zuordnung erstellen.
**Validierung:** `Get-SmbServerConfiguration | fl EnableSMB1Protocol,RequireSecuritySignature,EncryptData` · `Get-SmbServerCertificateMapping`

### A7 – Azure Files + File Sync
**Maschinen:** Azure-Portal, EXA-SRV03 (NAT-Internet)
**Auftrag:** Storage-Konto, Freigabe `itsync`, Speichersynchronisierungsdienst, Gruppe, Cloudendpunkt, Serverendpunkt `D:\IT` mit Cloud-Tiering 30 % frei.
**Leitfrage:** Warum klappt `net use` auf die Azure-Freigabe von zuhause evtl. nicht?
**Validierung (EXA-SRV03):** Ereignisanzeige *Microsoft-FileSync-Agent/Telemetry* Event 9102 (Sync-Sitzung ok).
