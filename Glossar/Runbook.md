---
aliases: [Azure Automation Runbook, Azure Automation, Hybrid Runbook Worker]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure Automation Runbook"
de: "Automatisierungsskript in Azure"
bereich: Virtualisierung-Cloud
---

# Runbook

PowerShell- oder Python-Skript in einem **Automation-Konto**, das zeitgesteuert, per Webhook oder Warnung läuft.

- Läuft in Azure oder auf einem **Hybrid Runbook Worker** (lokaler/Arc-Server)
- Anmeldung an Azure über die verwaltete Identität (`Connect-AzAccount -Identity`)

**Siehe auch:** [[Azure Arc]] · [[Azure Monitor]]
**Thema:** [[AZ-802 2 Hybride Verwaltung]] · [[AZ-802 Übersicht]]
