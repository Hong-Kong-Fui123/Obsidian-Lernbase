---
aliases:
  - "PowerShell"
  - "PS"
  - "Windows PowerShell"
  - "pwsh"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell"
de: "PowerShell (Kommandozeile und Skriptsprache)"
bereich: Scripting
---

**PowerShell** = *PowerShell*
**Deutsch:** PowerShell (Kommandozeile und Skriptsprache)

## Kurz
Objektorientierte Kommandozeile und Skriptsprache von Microsoft zur Verwaltung und Automatisierung.

> [!example] Für Kinder erklärt
> Ein Roboter, dem man Befehle zuruft oder einen Zettel mit vielen Befehlen gibt.

## Details
- Windows PowerShell 5.1 (`powershell.exe`) vorinstalliert, PowerShell 7 (`pwsh.exe`) plattformübergreifend
- Arbeitet mit Objekten statt Text
- Steuert AD, DNS, DHCP, Hyper-V, IIS, Azure

## Beispiel
Maschine: **Schul-PC**
```powershell
$PSVersionTable.PSVersion
Get-Command | Measure-Object
```

## Prüfungsfrage
Was ist der wichtigste Unterschied zwischen PowerShell und CMD?

> [!success]- Lösung
> PowerShell gibt Objekte mit Eigenschaften weiter, CMD nur Text.

## Siehe auch
[[Cmdlet]] · [[PS-Pipeline]] · [[CLI]] · [[01_PS-Grundlagen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
