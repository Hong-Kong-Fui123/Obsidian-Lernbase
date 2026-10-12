---
aliases:
  - "PS-Modul"
  - "Modul"
  - "Module"
  - "psm1"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Module"
de: "PowerShell-Modul"
bereich: Scripting
---

**PS-Modul** = *PowerShell Module*
**Deutsch:** PowerShell-Modul

## Kurz
Paket aus Funktionen/Cmdlets zum Wiederverwenden, z. B. `ActiveDirectory`.

> [!example] Für Kinder erklärt
> Ein Werkzeugkasten: Du holst ihn, und alle Werkzeuge darin sind sofort da.

## Details
- Dateien: `.psm1` (Code), `.psd1` (Manifest)
- `Import-Module`, `Get-Module -ListAvailable`
- Online: PowerShell Gallery `Install-Module`

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-Module -ListAvailable | Select-Object -First 10 Name, Version
Install-Module PSScriptAnalyzer -Scope CurrentUser
```

## Prüfungsfrage
Wo sucht PowerShell nach Modulen?

> [!success]- Lösung
> In den Ordnern aus `$env:PSModulePath`.

## Siehe auch
[[Funktion]] · [[PS-Skript]] · [[10_PS-Skripte-Module-Sicherheit]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
