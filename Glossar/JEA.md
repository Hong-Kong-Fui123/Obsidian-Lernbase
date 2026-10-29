---
aliases: [Just Enough Administration, Just-Enough-Administration]
tags: [glossar, glossar/sicherheit-pki, az-802]
en: "Just Enough Administration"
de: "Gerade genug Administration"
bereich: Sicherheit-PKI
---

# JEA

PowerShell-Remoting-Endpunkt, auf dem Benutzer nur **ausgewählte Befehle** ausführen – oft unter einem virtuellen Admin-Konto.

- Rollenfunktionsdatei `.psrc` (erlaubte Cmdlets) im Modulordner `RoleCapabilities`
- Sitzungskonfiguration `.pssc`: `RestrictedRemoteServer`, RunAs, Gruppe → Rolle, Transkript
- Aufruf: `Enter-PSSession -ComputerName … -ConfigurationName …`

Maschine: **EXA-SRV01**
```powershell
Register-PSSessionConfiguration -Name DnsOperator -Path C:\JEA\DnsOperator.pssc
Get-PSSessionConfiguration | Select-Object Name
```

**Siehe auch:** [[PS-Remoting]] · [[gMSA]] · [[WinRM]] · [[Rollenfunktionsdatei]] · [[Sitzungskonfiguration]] · [[Virtuelles Konto]]
**Thema:** [[JEA Übersicht]] (Unterkapitel) · [[AZ-802 2 Hybride Verwaltung]] · [[AZ-802 Übersicht]]
