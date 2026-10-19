---
aliases: [Secure Channel, Computerkonto-Vertrauensstellung]
tags: [glossar, glossar/windows-server, az-802]
en: "Secure Channel"
de: "Sicherer Kanal"
bereich: Windows-Server
---

# Sicherer Kanal

Vertrauensverbindung zwischen Domänenmitglied und DC über das Computerkonto-Kennwort.

- Defekt → „Vertrauensstellung zwischen dieser Arbeitsstation und der primären Domäne fehlgeschlagen“
- Ursache oft: alter Snapshot/Checkpoint, Konto zurückgesetzt

Maschine: **betroffener Server**
```powershell
Test-ComputerSecureChannel -Repair -Credential EXAMPLE\Administrator
nltest /sc_verify:example.com
```

**Siehe auch:** [[Kerberos]] · [[Checkpoint]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
