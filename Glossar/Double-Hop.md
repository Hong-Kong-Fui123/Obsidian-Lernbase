---
aliases: [Second Hop, Doppelhop]
tags: [glossar, glossar/hybrid, az-802]
en: Kerberos double hop
de: Zweiter Hop
bereich: hybrid
---
# Double-Hop

**Definition:** Remote-Sitzung kann Anmeldedaten nicht an einen dritten Server weitergeben.

**Prüfungsfalle:** Empfohlen: ressourcenbasierte eingeschränkte Delegierung (RBKCD); CredSSP unsicher.

**Prüfen:** `Get-ADComputer Ziel -Properties PrincipalsAllowedToDelegateToAccount`

↑ [[AZ-802 02 Hybrid-Verwaltung]] · [[00_Glossar-AZ-802-Index]]
