---
aliases: [Resilient File System]
tags: [glossar, glossar/speicher, az-802]
en: Resilient File System
de: Robustes Dateisystem
bereich: speicher
---
# ReFS

**Definition:** Dateisystem mit Integritätsstreams und Block-Cloning für S2D, Hyper-V, Backup.

**Prüfungsfalle:** Nicht bootfähig, kein EFS.

**Prüfen:** `Get-Volume | ft DriveLetter,FileSystem`

↑ [[AZ-802 05 Speicher und Dateidienste]] · [[00_Glossar-AZ-802-Index]]
