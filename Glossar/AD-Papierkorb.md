---
aliases: [AD Recycle Bin, Active Directory-Papierkorb, Papierkorb]
tags: [glossar, glossar/windows-server, az-802]
en: "Active Directory Recycle Bin"
de: "Active-Directory-Papierkorb"
bereich: Windows-Server
---

# AD-Papierkorb

Gelöschte AD-Objekte mit **allen Attributen** (inkl. Gruppenmitgliedschaften) wiederherstellen.

- Aktivieren einmal pro Gesamtstruktur, **nicht umkehrbar**, Funktionsebene ≥ 2008 R2
- Gilt nur für Objekte, die **nach** der Aktivierung gelöscht werden

Maschine: **EXA-DC01**
```powershell
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target example.com
Get-ADObject -Filter 'samAccountName -eq "hmeier"' -IncludeDeletedObjects | Restore-ADObject
```

**Siehe auch:** [[DSRM]] · [[AD]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
