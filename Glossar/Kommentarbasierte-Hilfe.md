---
aliases:
  - "Kommentarbasierte-Hilfe"
  - "Comment-based Help"
  - ".SYNOPSIS"
tags:
  - glossar
  - glossar/scripting
en: "Comment-based Help"
de: "Kommentarbasierte Hilfe"
bereich: Scripting
---

**Kommentarbasierte-Hilfe** = *Comment-based Help*
**Deutsch:** Kommentarbasierte Hilfe

## Kurz
Hilfe-Block mit Schlüsselwörtern im Kommentar, den `Get-Help` für eigene Skripte und Funktionen anzeigt.

> [!example] Für Kinder erklärt
> Eine Gebrauchsanleitung, die direkt am Spielzeug klebt.

## Details
- Schlüsselwörter: `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`, `.NOTES`
- Steht am Anfang der Funktion oder des Skripts
- `Get-Help .\skript.ps1 -Full`

## Beispiel
Maschine: **Schul-PC**
```powershell
<#
.SYNOPSIS
    Zeigt freien Speicher.
.EXAMPLE
    Get-FreierSpeicher -Laufwerk D
#>
```

## Prüfungsfrage
Welches Schlüsselwort zeigt Beispielaufrufe?

> [!success]- Lösung
> `.EXAMPLE`

## Siehe auch
[[Kommentar]] · [[Funktion]] · [[07_PS-Funktionen-Parameter]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
