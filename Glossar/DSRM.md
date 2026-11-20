---
aliases: [Verzeichnisdienstwiederherstellungsmodus]
tags: [glossar, glossar/monitoring, az-802]
en: Directory Services Restore Mode
de: Verzeichnisdienst-Wiederherstellungsmodus
bereich: monitoring
---
# DSRM

**Definition:** Startmodus eines DC mit gestopptem AD für Wiederherstellung/Wartung; lokales DSRM-Konto.

**Prüfungsfalle:** DSRM-Kennwort per `ntdsutil set dsrm password` oder Windows LAPS verwalten.

**Prüfen:** `bcdedit /set safeboot dsrepair`

↑ [[AZ-802 07 Ueberwachung und Troubleshooting]] · [[00_Glossar-AZ-802-Index]]
