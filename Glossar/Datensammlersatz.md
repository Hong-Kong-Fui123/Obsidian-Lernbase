---
aliases: [Data Collector Set, Datensammlersätze, logman]
tags: [glossar, glossar/windows-server, az-802]
en: "Data Collector Set"
de: "Datensammlersatz"
bereich: Windows-Server
---

# Datensammlersatz

Sammelt Leistungsindikatoren, Ablaufverfolgungen und Konfigurationsdaten über einen Zeitraum (Leistungsüberwachung).

- Vorlagen z. B. *System Performance*, Berichte unter *Berichte*
- Leistungswarnungen: Aktion bei Schwellwert

Maschine: **EXA-SRV01**
```powershell
logman create counter Basis -c '\Processor(_Total)\% Processor Time' -si 00:00:15
logman start Basis
```

**Siehe auch:** [[System Insights]] · [[Azure Monitor]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
