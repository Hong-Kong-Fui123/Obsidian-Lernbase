---
aliases: [Systemeinblicke]
tags: [glossar, glossar/windows-server, az-802]
en: "System Insights"
de: "Systemeinblicke"
bereich: Windows-Server
---

# System Insights

Lokale Vorhersagefunktion von Windows Server (Machine Learning) – z. B. wann ein Volume voll ist.

- Funktionen: CPU-, Netzwerk-, Gesamtspeicher- und Volumeverbrauchsprognose
- Verwaltung per PowerShell oder Windows Admin Center

Maschine: **EXA-SRV01**
```powershell
Add-WindowsFeature System-Insights -IncludeManagementTools
Get-InsightsCapability
```

**Siehe auch:** [[Datensammlersatz]] · [[Windows Admin Center]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
