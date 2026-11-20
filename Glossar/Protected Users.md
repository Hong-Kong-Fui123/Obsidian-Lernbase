---
aliases: [Geschützte Benutzer]
tags: [glossar, glossar/sicherheit, az-802]
en: Protected Users group
de: Geschützte Benutzer
bereich: sicherheit
---
# Protected Users

**Definition:** Sicherheitsgruppe: kein NTLM, kein RC4/DES, keine Delegierung, TGT 4 h, keine Cache-Anmeldung.

**Prüfungsfalle:** Nicht für Dienst- oder Computerkonten.

**Prüfen:** `Get-ADGroupMember 'Protected Users'`

↑ [[AZ-802 06 Sicherheit]] · [[00_Glossar-AZ-802-Index]]
