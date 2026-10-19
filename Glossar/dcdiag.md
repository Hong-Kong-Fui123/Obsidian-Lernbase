---
aliases: [Domain Controller Diagnostics]
tags: [glossar, glossar/windows-server, az-802]
en: "Domain Controller Diagnostics"
de: "DC-Diagnose"
bereich: Windows-Server
---

# dcdiag

Testet einen Domänencontroller umfassend (Konnektivität, Replikation, DNS, SYSVOL, FSMO …).

- `/v` ausführlich · `/c` alle Tests · `/e` alle DCs · `/test:dns` nur DNS

Maschine: **EXA-DC01**
```powershell
dcdiag /v /c /f:C:\Temp\dcdiag.txt
```

**Siehe auch:** [[repadmin]] · [[DC]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
