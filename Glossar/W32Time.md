---
aliases: [Windows-Zeitdienst, w32tm, Zeitdienst]
tags: [glossar, glossar/windows-server, az-802]
en: "Windows Time Service"
de: "Windows-Zeitdienst"
bereich: Windows-Server
---

# W32Time

Hält die Uhrzeit in der Domäne synchron – wichtig für [[Kerberos]] (max. 5 Min. Abweichung).

- Hierarchie: PDC-Emulator der Stammdomäne (externe Quelle) → DCs → Mitglieder
- Befehle: `w32tm /query /status`, `/query /source`, `/resync`

Maschine: **EXA-DC01 (PDC-Emulator)**
```powershell
w32tm /config /manualpeerlist:"de.pool.ntp.org,0x8" /syncfromflags:manual /reliable:yes /update
w32tm /query /status
```

**Siehe auch:** [[NTP]] · [[FSMO]] · [[Kerberos]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
