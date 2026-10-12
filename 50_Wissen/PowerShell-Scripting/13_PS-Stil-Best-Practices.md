---
title: PowerShell – Stil und Best Practices
tags: [powershell, best-practices, psscriptanalyzer]
kapitel: "[[00_PS-Uebersicht]]"
---

# 13 PowerShell – Stil und Best Practices
← [[12_PS-Praxis-Lab]] · → [[14_PS-Aufgaben]]

> [!example] Für Kinder erklärt
> Sauber programmieren ist wie **ordentlich ins Heft schreiben**: Andere (und du selbst nächste Woche!) sollen es lesen können. Ein unordentliches Heft funktioniert vielleicht auch – aber niemand findet etwas.

## Regeln

| Bereich | Regel | Schlecht | Gut |
|---|---|---|---|
| Namen | Funktionen [[Verb-Nomen]] mit erlaubtem Verb | `function machBackup` | `function Start-LabBackup` |
| Namen | sprechende Variablen | `$x`, `$tmp2` | `$serverListe` |
| Aliase | keine Aliase im Skript | `gci \| ? {$_.len -gt 1mb}` | `Get-ChildItem \| Where-Object Length -gt 1MB` |
| Parameter | benannt statt Position | `Get-ChildItem C:\ *.log` | `Get-ChildItem -Path C:\ -Filter *.log` |
| Werte | keine festen Werte im Code | `'C:\Users\ITA7-TN10\x'` | Parameter mit Standardwert |
| Ausgabe | Objekte statt Text | `Write-Host "$name $status"` | `[pscustomobject]@{Name=$name;Status=$status}` |
| Sicherheit | keine Passwörter im Klartext | `$pw = 'Geheim1!'` | `Get-Credential`, `Read-Host -AsSecureString` |
| Gefährliche Aktionen | `-WhatIf`-Unterstützung | direkt `Remove-Item` | `SupportsShouldProcess` |
| Fehler | `-ErrorAction Stop` + `try/catch` | Fehler ignorieren | gezielt abfangen und loggen |
| Kommentare | erklären **warum**, nicht **was** | `# Schleife` | `# Altkonten vor Löschung 30 Tage behalten (Datenschutz)` |
| Länge | Zeilen < 115 Zeichen, Funktionen kurz | 300-Zeilen-Block | kleine Funktionen |
| Einrückung | 4 Leerzeichen, Klammer auf gleicher Zeile | | `if ($x) {` |
| Kodierung | UTF-8 mit BOM (5.1) | ANSI | UTF-8 BOM |
| Versionierung | Git, sinnvolle Commit-Texte | `skript_neu_final2.ps1` | `git commit -m "Log ergänzt"` |

## PSScriptAnalyzer
[[PSScriptAnalyzer]] prüft Skripte automatisch auf diese Regeln.
```powershell
# Maschine: Schul-PC (einmalig, Internet)
Install-Module PSScriptAnalyzer -Scope CurrentUser

# Maschine: Schul-PC
Invoke-ScriptAnalyzer -Path C:\Skripte -Recurse | Select-Object RuleName, Severity, ScriptName, Line, Message
Invoke-ScriptAnalyzer -Path C:\Skripte\New-LabBenutzer.ps1 -Fix          # einfache Fehler automatisch beheben
```
| Schweregrad | Bedeutung |
|---|---|
| Error | muss behoben werden |
| Warning | sollte behoben werden (z. B. Alias, `Write-Host`) |
| Information | Hinweis |

In VS Code läuft der Analyzer automatisch (gelbe/rote Unterstreichungen).

## Checkliste vor dem Einsatz
- [ ] Hilfe-Block (`.SYNOPSIS`, `.EXAMPLE`)
- [ ] `[CmdletBinding()]` und `param()` mit Validierung
- [ ] `-WhatIf` bei ändernden Aktionen getestet
- [ ] Fehlerbehandlung und Log
- [ ] PSScriptAnalyzer ohne Error/Warning
- [ ] Pester-Tests grün
- [ ] Mit **Testdaten** im Lab geprüft, nicht zuerst in Produktion
- [ ] In Git eingecheckt, ggf. signiert
