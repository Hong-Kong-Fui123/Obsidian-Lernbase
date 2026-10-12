---
aliases:
  - "Pester"
  - "Pester-Test"
  - "Unit-Test PowerShell"
tags:
  - glossar
  - glossar/scripting
en: "Pester"
de: "Pester (Test-Framework)"
bereich: Scripting
---

**Pester** = *Pester*
**Deutsch:** Pester (Test-Framework)

## Kurz
Test-Framework für PowerShell: prüft automatisch, ob Funktionen die erwarteten Ergebnisse liefern.

> [!example] Für Kinder erklärt
> Eine Kuchenprobe: Mit festen Zutaten muss es immer gleich schmecken – grün = stimmt, rot = stimmt nicht.

## Details
- Aufbau: `Describe` → `It` → `Should`
- Starten: `Invoke-Pester`
- Windows liefert alte Version 3.4; aktuell Version 5 per `Install-Module`

## Beispiel
Maschine: **Schul-PC**
```powershell
Describe 'Addition' {
    It 'rechnet richtig' { 2 + 2 | Should -Be 4 }
}
```

## Prüfungsfrage
Warum automatische Tests statt Ausprobieren?

> [!success]- Lösung
> Nach jeder Änderung in Sekunden wiederholbar; Fehler fallen sofort auf.

## Siehe auch
[[PSScriptAnalyzer]] · [[CI-CD]] · [[12_PS-Praxis-Lab]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
