---
aliases: [File Sync, AFS]
tags: [glossar, glossar/speicher, az-802]
en: Azure File Sync
de: Azure-Dateisynchronisierung
bereich: speicher
---
# Azure File Sync

**Definition:** Synchronisiert Windows-Dateiserver mit Azure Files: Dienst → Gruppe → 1 Cloud- + n Serverendpunkte.

**Prüfungsfalle:** Pro Sync-Gruppe genau ein Cloudendpunkt.

**Prüfen:** `Get-AzStorageSyncServerEndpoint`

↑ [[AZ-802 05 Speicher und Dateidienste]] · [[00_Glossar-AZ-802-Index]]
