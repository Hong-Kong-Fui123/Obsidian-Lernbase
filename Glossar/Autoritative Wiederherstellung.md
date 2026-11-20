---
aliases: [Authoritative Restore]
tags: [glossar, glossar/monitoring, az-802]
en: Authoritative restore
de: Autoritative Wiederherstellung
bereich: monitoring
---
# Autoritative Wiederherstellung

**Definition:** Wiederhergestellte Objekte erhalten höhere Versionsnummer und überschreiben Replikationspartner.

**Prüfungsfalle:** Nicht-autoritativ = DC holt sich danach den aktuellen Stand der Partner.

**Prüfen:** `ntdsutil "authoritative restore"`

↑ [[AZ-802 07 Ueberwachung und Troubleshooting]] · [[00_Glossar-AZ-802-Index]]
