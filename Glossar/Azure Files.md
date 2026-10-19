---
aliases: [Azure-Dateifreigabe, Azure File Share, Azure Dateien]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure Files"
de: "Azure-Dateifreigaben"
bereich: Virtualisierung-Cloud
---

# Azure Files

Vollständig verwaltete Dateifreigaben in einem Azure-Speicherkonto, Zugriff per **SMB 3 (TCP 445)** oder NFS.

- Rechte: Freigabe über Azure-RBAC (*Storage File Data SMB Share …*), Ordner/Dateien über NTFS-ACLs
- Identität: AD DS, Entra Kerberos oder Entra Domain Services
- Stufen: Premium, Transaktionsoptimiert, Heiß, Kalt; Momentaufnahmen und vorläufiges Löschen

**Siehe auch:** [[Azure File Sync]] · [[SMB]] · [[NTFS]]
**Thema:** [[AZ-802 5 Speicher und Dateidienste]] · [[AZ-802 Übersicht]]
