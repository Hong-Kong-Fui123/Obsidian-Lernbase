---
aliases: [psrc, Role Capability, Role Capability File, Rollenfunktion]
tags: [glossar, glossar/sicherheit-pki, az-802, jea]
en: "Role Capability File"
de: "Rollenfunktionsdatei"
bereich: Sicherheit-PKI
---

# Rollenfunktionsdatei

JEA-Datei (`.psrc`), die festlegt, **welche Befehle, Parameter und Werte** eine Rolle nutzen darf.

- Muss in `<Modul>\RoleCapabilities\` unter `$env:PSModulePath` liegen; Rollenname = Dateiname
- Felder: VisibleCmdlets, VisibleFunctions, VisibleExternalCommands, ModulesToImport, FunctionDefinitions
- Mehr: [[JEA Rollenfunktionsdatei]]

Maschine: **EXA-SRV01**
```powershell
New-PSRoleCapabilityFile -Path "$m\RoleCapabilities\DnsOperator.psrc" -VisibleCmdlets 'Get-DnsServerZone'
```

**Siehe auch:** [[Sitzungskonfiguration]] · [[JEA]]
**Thema:** [[JEA Übersicht]] · [[AZ-802 2 Hybride Verwaltung]]
