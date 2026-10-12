---
aliases:
  - "PS-Skript"
  - "Skript"
  - "ps1"
  - "PowerShell-Skript"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Script"
de: "PowerShell-Skript"
bereich: Scripting
---

**PS-Skript** = *PowerShell Script*
**Deutsch:** PowerShell-Skript

## Kurz
Textdatei mit der Endung `.ps1`, die PowerShell-Befehle der Reihe nach enthält.

> [!example] Für Kinder erklärt
> Ein gespeicherter Zettel mit allen Befehlen, den der Roboter immer wieder abarbeitet.

## Details
- Start mit `.\name.ps1` (Pfad ist Pflicht)
- Kann Parameter, Hilfe und `#Requires` enthalten
- Unter 5.1 als UTF-8 mit BOM speichern (Umlaute)

## Beispiel
Maschine: **Schul-PC**
```powershell
.\Vorlage.ps1 -Pfad C:\Temp -WhatIf
Get-Help .\Vorlage.ps1 -Full
```

## Prüfungsfrage
Warum startet `skript.ps1` nicht, `.\skript.ps1` aber schon?

> [!success]- Lösung
> PowerShell sucht nicht im aktuellen Ordner; `.\` gibt den Ort ausdrücklich an (Schutz vor untergeschobenen Dateien).

## Siehe auch
[[Execution-Policy]] · [[PS-Modul]] · [[Kommentarbasierte-Hilfe]] · [[10_PS-Skripte-Module-Sicherheit]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
