---
aliases: [Replikationsdiagnose]
tags: [glossar, glossar/windows-server, az-802]
en: "Replication Administration"
de: "AD-Replikationswerkzeug"
bereich: Windows-Server
---

# repadmin

Kommandozeilenwerkzeug zur Prüfung und Steuerung der AD-Replikation.

- `/replsummary` Überblick · `/showrepl` Details je DC · `/syncall /AdeP` alles sofort replizieren · `/queue` Warteschlange

Maschine: **EXA-DC01**
```powershell
repadmin /replsummary
repadmin /showrepl EXA-DC02
```

**Siehe auch:** [[dcdiag]] · [[AD-Standort]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
