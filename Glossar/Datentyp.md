---
aliases:
  - "Datentyp"
  - "Typ"
  - "Type"
tags:
  - glossar
  - glossar/scripting
en: "Data Type"
de: "Datentyp"
bereich: Scripting
---

**Datentyp** = *Data Type*
**Deutsch:** Datentyp

## Kurz
Art eines Wertes, z. B. Text, ganze Zahl, Wahrheitswert, Datum.

> [!example] Für Kinder erklärt
> Die Form des Kartons: Im Eierkarton haben nur Eier Platz.

## Details
- `[string]` Text · `[int]` ganze Zahl · `[double]` Kommazahl · `[bool]` wahr/falsch · `[datetime]` Datum
- Typ anzeigen: `$x.GetType()`
- Typ erzwingen: `[int]$x = '5'`

## Beispiel
Maschine: **Schul-PC**
```powershell
[int]'42' + 1        # 43
'42' + 1             # 421 (Text!)
```

## Prüfungsfrage
Warum ergibt `'5' + 1` den Wert `51`?

> [!success]- Lösung
> Der linke Wert ist Text; `+` verbindet dann Text.

## Siehe auch
[[Variable]] · [[02_PS-Variablen-Datentypen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
