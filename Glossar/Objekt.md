---
aliases:
  - "Objekt"
  - "Object"
tags:
  - glossar
  - glossar/scripting
en: "Object"
de: "Objekt"
bereich: Scripting
---

**Objekt** = *Object*
**Deutsch:** Objekt

## Kurz
Datenpaket mit Eigenschaften (Werten) und Methoden (Aktionen). PowerShell gibt immer Objekte aus.

> [!example] Für Kinder erklärt
> Eine Sammelkarte: vorne stehen Werte, hinten, was die Figur kann.

## Details
- Inhalt ansehen: `Get-Member`
- Eigene Objekte: `[pscustomobject]@{ … }`
- Objekte lassen sich filtern, sortieren, exportieren

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-Service Spooler | Get-Member
[pscustomobject]@{ Server = 'EXA-DC01'; Online = $true }
```

## Prüfungsfrage
Warum sind Objekte praktischer als Text?

> [!success]- Lösung
> Werte sind direkt über Eigenschaften erreichbar, kein Zerschneiden von Text nötig.

## Siehe auch
[[Eigenschaft]] · [[Methode]] · [[PS-Pipeline]] · [[04_PS-Objekte-Pipeline]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
