---
aliases: [Datendeduplizierung, Data Deduplication, Dedup]
tags: [glossar, glossar/hardware-storage, az-802]
en: "Data Deduplication"
de: "Datendeduplizierung"
bereich: Hardware-Storage
---

# Deduplizierung

Speichert doppelte Datenblöcke eines Volumes nur einmal.

- Profile: Allgemeiner Dateiserver, Hyper-V (VDI), Sicherung
- Nicht auf System-/Startvolume; Server 2025: auch nativ für ReFS

Maschine: **EXA-SRV01**
```powershell
Enable-DedupVolume -Volume D: -UsageType Default
Get-DedupStatus
```

**Siehe auch:** [[NTFS]] · [[ReFS]]
**Thema:** [[AZ-802 5 Speicher und Dateidienste]] · [[AZ-802 Übersicht]]
