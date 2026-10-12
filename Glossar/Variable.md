---
aliases:
  - "Variable"
  - "Var"
tags:
  - glossar
  - glossar/scripting
en: "Variable"
de: "Variable (benannter Speicherplatz)"
bereich: Scripting
---

**Variable** = *Variable*
**Deutsch:** Variable (benannter Speicherplatz)

## Kurz
Benannter Speicherplatz für einen Wert. In PowerShell beginnt der Name mit `$`.

> [!example] Für Kinder erklärt
> Ein Schuhkarton mit Namensschild, in den man etwas hineinlegt und austauschen kann.

## Details
- Zuweisung mit `=`
- Groß-/Kleinschreibung egal
- Typ kann festgelegt werden: `[int]$port = 80`
- Lokal in Funktionen, `$script:` / `$global:` für größere Bereiche

## Beispiel
Maschine: **Schul-PC**
```powershell
$server = 'EXA-DC01'
"Ziel: $server"
$server.GetType().Name
```

## Prüfungsfrage
Was gibt `"$a + $b"` aus, wenn `$a = 2` und `$b = 3`?

> [!success]- Lösung
> Den Text `2 + 3` – in Anführungszeichen wird nicht gerechnet.

## Siehe auch
[[Datentyp]] · [[Array]] · [[Hashtable]] · [[02_PS-Variablen-Datentypen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
