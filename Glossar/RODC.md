---
aliases: [Read-Only DC]
tags: [glossar, glossar/ad-ds, az-802]
en: Read-Only Domain Controller
de: Schreibgeschützter DC
bereich: ad-ds
---
# RODC

**Definition:** DC ohne Schreibzugriff für unsichere Standorte; speichert nur Kennwörter erlaubter Konten (PRP).

**Prüfungsfalle:** Standardmäßig keine Kennwörter zwischengespeichert.

**Prüfen:** `Get-ADDomainControllerPasswordReplicationPolicy -Identity RODC -Allowed`

↑ [[AZ-802 01 AD DS]] · [[00_Glossar-AZ-802-Index]]
