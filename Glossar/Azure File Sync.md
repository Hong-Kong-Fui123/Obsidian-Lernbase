---
aliases: [File Sync, Azure-Dateisynchronisierung, Speichersynchronisierungsdienst]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure File Sync"
de: "Azure-Dateisynchronisierung"
bereich: Virtualisierung-Cloud
---

# Azure File Sync

Synchronisiert Windows-Dateiserver mit einer [[Azure Files|Azure-Dateifreigabe]] – der Server wird zum Cache.

- Speichersynchronisierungsdienst → Synchronisierungsgruppe → **1** Cloudendpunkt + Serverendpunkte
- Agent auf dem Server, nur ausgehend HTTPS 443
- Mit [[Cloud-Tiering]] bleiben selten genutzte Dateien nur in Azure

**Siehe auch:** [[Cloud-Tiering]] · [[DFSR]] · [[Azure Files]]
**Thema:** [[AZ-802 5 Speicher und Dateidienste]] · [[AZ-802 Übersicht]]
