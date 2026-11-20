---
aliases: [Betriebsmaster, FSMO-Rollen]
tags: [glossar, glossar/ad-ds, az-802]
en: Flexible Single Master Operations
de: Betriebsmasterrollen
bereich: ad-ds
---
# FSMO

**Definition:** 5 Rollen, die nur ein DC halten darf: Schema, Domain Naming (Forest); RID, PDC, Infrastructure (Domäne).

**Prüfungsfalle:** Transfer = geordnet; Seize (`-Force`) = alter DC nie wieder online.

**Prüfen:** `netdom query fsmo`

↑ [[AZ-802 01 AD DS]] · [[00_Glossar-AZ-802-Index]]
