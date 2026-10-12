---
aliases:
  - "Operator"
  - "Operatoren"
tags:
  - glossar
  - glossar/scripting
en: "Operator"
de: "Operator"
bereich: Scripting
---

**Operator** = *Operator*
**Deutsch:** Operator

## Kurz
Zeichen oder Schlüsselwort, das Werte verknüpft, vergleicht oder verändert.

> [!example] Für Kinder erklärt
> Die Rechenzeichen zwischen den Zahlen – oder die Frage „Ist das gleich?“.

## Details
- Rechnen: `+ - * / %`
- Vergleich: `-eq -ne -gt -lt -like -match`
- Logik: `-and -or -not`
- Nicht `=` zum Vergleichen verwenden!

## Beispiel
Maschine: **Schul-PC**
```powershell
5 -gt 3
'EXA-DC01' -like 'EXA-*'
```

## Prüfungsfrage
Welcher Operator prüft „kleiner oder gleich“?

> [!success]- Lösung
> `-le`

## Siehe auch
[[Bedingung]] · [[03_PS-Operatoren]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
