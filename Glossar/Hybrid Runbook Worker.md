---
aliases: [HRW]
tags: [glossar, glossar/hybrid, az-802]
en: Hybrid Runbook Worker
de: Hybrider Runbook-Worker
bereich: hybrid
---
# Hybrid Runbook Worker

**Definition:** Führt Azure-Automation-Runbooks auf lokalen/Arc-Servern aus (erweiterungsbasiert).

**Prüfungsfalle:** Authentifizierung über verwaltete Identität, nicht mehr Run-As-Konto.

**Prüfen:** `Get-AzAutomationHybridRunbookWorkerGroup`

↑ [[AZ-802 02 Hybrid-Verwaltung]] · [[00_Glossar-AZ-802-Index]]
