---
aliases: [LAPS]
tags: [glossar, glossar/sicherheit, az-802]
en: Windows Local Administrator Password Solution
de: Lösung für lokale Administratorkennwörter
bereich: sicherheit
---
# Windows LAPS

**Definition:** Rotiert lokale Admin-/DSRM-Kennwörter, speichert sie (verschlüsselt) in AD DS oder Entra ID.

**Prüfungsfalle:** Eingebaut seit 2023; Legacy-LAPS nicht mehr verwenden.

**Prüfen:** `Get-LapsADPassword SERVER -AsPlainText`

↑ [[AZ-802 06 Sicherheit]] · [[00_Glossar-AZ-802-Index]]
