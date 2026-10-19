---
aliases: [Directory Services Restore Mode, Verzeichnisdienst-Wiederherstellungsmodus]
tags: [glossar, glossar/windows-server, az-802]
en: "Directory Services Restore Mode"
de: "Verzeichnisdienst-Wiederherstellungsmodus"
bereich: Windows-Server
---

# DSRM

Startmodus eines DC, in dem AD DS **nicht** läuft – zum Zurücksichern und Reparieren der AD-Datenbank.

- Anmeldung mit dem lokalen **DSRM-Kennwort** (bei der Heraufstufung vergeben)
- Autoritative Wiederherstellung mit `ntdsutil`

Maschine: **EXA-DC01**
```powershell
bcdedit /set safeboot dsrepair
Restart-Computer
# zurück: bcdedit /deletevalue safeboot
```

**Siehe auch:** [[AD-Papierkorb]] · [[DC]]
**Thema:** [[AZ-802 7 Überwachung und Problembehandlung]] · [[AZ-802 Übersicht]]
