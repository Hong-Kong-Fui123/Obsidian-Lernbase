---
aliases: [pssc, Session Configuration, Sitzungskonfigurationsdatei, PSSessionConfiguration]
tags: [glossar, glossar/sicherheit-pki, az-802, jea]
en: "Session Configuration"
de: "Sitzungskonfiguration"
bereich: Sicherheit-PKI
---

# Sitzungskonfiguration

Benannter PowerShell-Remoting-Endpunkt; bei JEA aus einer `.pssc`-Datei: wer darf sich verbinden, welche Rolle, welches RunAs-Konto, Transkript.

- Für JEA immer `SessionType RestrictedRemoteServer` (NoLanguage)
- `RoleDefinitions`: Gruppe → Rolle(n)
- Registrieren mit `Register-PSSessionConfiguration` (startet WinRM neu)
- Mehr: [[JEA Sitzungskonfiguration]]

Maschine: **EXA-SRV01**
```powershell
Register-PSSessionConfiguration -Name DnsOperator -Path C:\JEA\DnsOperator.pssc
Get-PSSessionConfiguration
```

**Siehe auch:** [[Rollenfunktionsdatei]] · [[Virtuelles Konto]] · [[WinRM]]
**Thema:** [[JEA Übersicht]] · [[AZ-802 2 Hybride Verwaltung]]
