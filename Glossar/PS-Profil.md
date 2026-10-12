---
aliases:
  - "PS-Profil"
  - "Profil"
  - "$PROFILE"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Profile"
de: "PowerShell-Profil"
bereich: Scripting
---

**PS-Profil** = *PowerShell Profile*
**Deutsch:** PowerShell-Profil

## Kurz
Skript, das bei jedem Start einer PowerShell-Sitzung automatisch läuft.

> [!example] Für Kinder erklärt
> Dein Lieblingsplatz, der sich jeden Morgen von selbst so einrichtet, wie du es magst.

## Details
- Pfad: `$PROFILE`
- Für eigene Funktionen, Aliase, Startordner
- Getrennt für 5.1, 7 und VS Code

## Beispiel
Maschine: **Schul-PC**
```powershell
if (-not (Test-Path $PROFILE)) { New-Item $PROFILE -Force }
notepad $PROFILE
```

## Prüfungsfrage
Warum gehören wichtige Funktionen nicht nur ins Profil?

> [!success]- Lösung
> Skripte auf anderen Rechnern oder in der Aufgabenplanung laden das Profil nicht.

## Siehe auch
[[PS-Modul]] · [[01_PS-Grundlagen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
