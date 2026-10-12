---
aliases:
  - "PSScriptAnalyzer"
  - "Script Analyzer"
  - "Linter"
tags:
  - glossar
  - glossar/scripting
en: "PSScriptAnalyzer"
de: "Statische Code-Analyse für PowerShell"
bereich: Scripting
---

**PSScriptAnalyzer** = *PSScriptAnalyzer*
**Deutsch:** Statische Code-Analyse für PowerShell

## Kurz
Werkzeug, das Skripte ohne Ausführung auf Fehler, Sicherheitsprobleme und Stilregeln prüft.

> [!example] Für Kinder erklärt
> Eine Lehrerin, die dein Heft durchsieht und Fehler rot anstreicht, bevor du es abgibst.

## Details
- `Invoke-ScriptAnalyzer -Path . -Recurse`
- Schweregrade: Error, Warning, Information
- In VS Code automatisch aktiv

## Beispiel
Maschine: **Schul-PC**
```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
Invoke-ScriptAnalyzer -Path C:\Skripte -Recurse
```

## Prüfungsfrage
Was ist der Unterschied zwischen PSScriptAnalyzer und Pester?

> [!success]- Lösung
> Analyzer prüft den Code-Text (Stil, Risiken), Pester prüft das Verhalten beim Ausführen.

## Siehe auch
[[Pester]] · [[CI-CD]] · [[13_PS-Stil-Best-Practices]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
