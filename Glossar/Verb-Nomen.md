---
aliases:
  - "Verb-Nomen"
  - "Verb-Noun"
tags:
  - glossar
  - glossar/scripting
en: "Verb-Noun naming"
de: "Verb-Nomen-Namensschema"
bereich: Scripting
---

**Verb-Nomen** = *Verb-Noun naming*
**Deutsch:** Verb-Nomen-Namensschema

## Kurz
Benennungsregel für Cmdlets und Funktionen: zugelassenes Verb + Bindestrich + Nomen in Einzahl.

> [!example] Für Kinder erklärt
> Erst sagen, was man tut, dann womit: „Starte-Dienst“.

## Details
- Erlaubte Verben: `Get-Verb`
- Nomen in Einzahl: `Get-Service`, nicht `Get-Services`
- Eigene Präfixe vermeiden Namenskonflikte: `Get-LabServer`

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-Verb | Where-Object Group -eq 'Lifecycle'
```

## Prüfungsfrage
Warum `Start-LabBackup` statt `machBackup`?

> [!success]- Lösung
> Einheitlich, auffindbar über `Get-Command -Verb Start`, kein Analyzer-Warnhinweis.

## Siehe auch
[[Cmdlet]] · [[Funktion]] · [[01_PS-Grundlagen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
