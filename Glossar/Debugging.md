---
aliases:
  - "Debugging"
  - "Fehlersuche"
  - "Debugger"
  - "Haltepunkt"
tags:
  - glossar
  - glossar/scripting
en: "Debugging"
de: "Fehlersuche im Code"
bereich: Scripting
---

**Debugging** = *Debugging*
**Deutsch:** Fehlersuche im Code

## Kurz
Systematisches Suchen und Beheben von Fehlern im Programm.

> [!example] Für Kinder erklärt
> Das Rezept Schritt für Schritt nachkochen und nach jedem Schritt probieren, wo es schiefging.

## Details
- Haltepunkte (Breakpoints) in VS Code, `F5` / `F10` / `F11`
- `Set-PSBreakpoint`, `Write-Verbose`, `Set-StrictMode`
- Logikfehler finden, die keine Fehlermeldung erzeugen

## Beispiel
Maschine: **Schul-PC**
```powershell
Set-PSBreakpoint -Script C:\Skripte\Vorlage.ps1 -Line 25
Set-StrictMode -Version Latest
```

## Prüfungsfrage
Was bewirkt `Set-StrictMode -Version Latest`?

> [!success]- Lösung
> Nicht definierte Variablen und ähnliche Fehler führen zu Fehlermeldungen statt stillem Weiterlaufen.

## Siehe auch
[[Try-Catch]] · [[Syntax]] · [[08_PS-Fehlerbehandlung-Debugging]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
