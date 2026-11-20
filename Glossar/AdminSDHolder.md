---
aliases: [SDProp]
tags: [glossar, glossar/sicherheit, az-802]
en: AdminSDHolder
de: AdminSDHolder
bereich: sicherheit
---
# AdminSDHolder

**Definition:** Vorlage-ACL für geschützte Admin-Konten; SDProp überschreibt deren ACL alle 60 Min.

**Prüfungsfalle:** Erklärt, warum Delegierung auf Admin-Konten „verschwindet“ (adminCount=1).

**Prüfen:** `Get-ADUser -Filter {adminCount -eq 1}`

↑ [[AZ-802 06 Sicherheit]] · [[00_Glossar-AZ-802-Index]]
