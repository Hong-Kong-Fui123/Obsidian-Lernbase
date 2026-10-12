---
aliases:
  - "CmdletBinding"
  - "Advanced Function"
  - "erweiterte Funktion"
tags:
  - glossar
  - glossar/scripting
en: "CmdletBinding"
de: "Erweiterte Funktion"
bereich: Scripting
---

**CmdletBinding** = *CmdletBinding*
**Deutsch:** Erweiterte Funktion

## Kurz
Attribut, das eine Funktion zu einer erweiterten Funktion macht – sie verhält sich wie ein Cmdlet.

> [!example] Für Kinder erklärt
> Ein Spielzeug bekommt Profi-Knöpfe: „Erklär mir genau“ (-Verbose) und „Was wäre wenn?“ (-WhatIf).

## Details
- Gemeinsame Parameter `-Verbose`, `-ErrorAction` automatisch
- `SupportsShouldProcess` → `-WhatIf`, `-Confirm`
- Prüfung im Code: `$PSCmdlet.ShouldProcess()`

## Beispiel
Maschine: **Schul-PC**
```powershell
function Remove-Test {
    [CmdletBinding(SupportsShouldProcess)]
    param([string]$Pfad)
    if ($PSCmdlet.ShouldProcess($Pfad,'Löschen')) { Remove-Item $Pfad }
}
```

## Prüfungsfrage
Was passiert bei `Remove-Test -Pfad x -WhatIf`?

> [!success]- Lösung
> Es wird nur angezeigt, was gelöscht würde; nichts wird gelöscht.

## Siehe auch
[[Funktion]] · [[Cmdlet]] · [[07_PS-Funktionen-Parameter]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
