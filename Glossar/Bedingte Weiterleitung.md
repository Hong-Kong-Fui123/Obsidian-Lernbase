---
aliases: [Conditional Forwarder]
tags: [glossar, glossar/netzwerk, az-802]
en: Conditional Forwarder
de: Bedingte Weiterleitung
bereich: netzwerk
---
# Bedingte Weiterleitung

**Definition:** DNS leitet Anfragen für eine bestimmte Domäne an festgelegte Server.

**Prüfungsfalle:** ≠ Stubzone (Stub lernt NS selbst); im AD replizierbar.

**Prüfen:** `Get-DnsServerZone | ? ZoneType -eq Forwarder`

↑ [[AZ-802 04 Netzwerk DNS DHCP]] · [[00_Glossar-AZ-802-Index]]
