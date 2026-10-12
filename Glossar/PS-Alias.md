---
aliases:
  - "PS-Alias"
  - "Alias (PowerShell)"
tags:
  - glossar
  - glossar/scripting
en: "Alias"
de: "Kurzname für Befehle"
bereich: Scripting
---

**PS-Alias** = *Alias*
**Deutsch:** Kurzname für Befehle

## Kurz
Alternativer Kurzname für ein Cmdlet, z. B. `dir` für `Get-ChildItem`.

> [!example] Für Kinder erklärt
> Ein Spitzname: Maximilian heißt für Freunde einfach Max.

## Details
- Anzeigen: `Get-Alias`
- Eigene: `Set-Alias`
- In Skripten vermeiden (Lesbarkeit)

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-Alias dir, ls, ?, %
```

## Prüfungsfrage
Welches Cmdlet steckt hinter `?`?

> [!success]- Lösung
> `Where-Object`

## Siehe auch
[[Cmdlet]] · [[PSScriptAnalyzer]] · [[01_PS-Grundlagen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
