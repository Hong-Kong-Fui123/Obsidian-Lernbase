---
aliases:
  - "Array"
  - "Liste"
  - "Feld"
tags:
  - glossar
  - glossar/scripting
en: "Array"
de: "Array (Liste)"
bereich: Scripting
---

**Array** = *Array*
**Deutsch:** Array (Liste)

## Kurz
Geordnete Liste mehrerer Werte, Zugriff über die Position (Index) ab 0.

> [!example] Für Kinder erklärt
> Ein Eierkarton mit nummerierten Fächern – das erste Fach hat die Nummer 0.

## Details
- Anlegen: `@('a','b')` oder `'a','b'`
- Zugriff: `$x[0]`, letztes Element `$x[-1]`
- Anzahl: `.Count`; Prüfen: `-contains`

## Beispiel
Maschine: **Schul-PC**
```powershell
$s = 'EXA-DC01','EXA-SRV01'
$s[0]; $s.Count
```

## Prüfungsfrage
Wie greifst du auf das dritte Element zu?

> [!success]- Lösung
> `$x[2]`

## Siehe auch
[[Hashtable]] · [[Schleife]] · [[02_PS-Variablen-Datentypen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
