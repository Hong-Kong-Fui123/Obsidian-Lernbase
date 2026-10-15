---
aliases: [Continuous Availability, Transparent Failover, ContinuouslyAvailable]
tags: [glossar, glossar/windows-server]
en: Continuous Availability
de: Fortlaufende Verfügbarkeit
bereich: windows-server
---

# Fortlaufende Verfügbarkeit

SMB-3-Freigabeoption: offene Dateien bleiben beim Failover offen (persistente Handles + [[SMB-Zeuge]]). `New-SmbShare -ContinuouslyAvailable $true`. Nicht mit FSRM-Kontingenten/Dateiprüfung kombinierbar.

**Siehe auch:** [[SMB]] · [[SMB-Zeuge]] · [[SoFS]]
**Thema:** [[Cluster und Failover]] · Mehr: [[Hochverfügbarer Dateiserver#2. Fortlaufende Verfügbarkeit (Continuous Availability)|Fortlaufende Verfügbarkeit]]
