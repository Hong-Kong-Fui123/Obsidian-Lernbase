---
aliases:
  - "Bedingung"
  - "if"
  - "Verzweigung"
  - "switch"
tags:
  - glossar
  - glossar/scripting
en: "Condition"
de: "Bedingung (Verzweigung)"
bereich: Scripting
---

**Bedingung** = *Condition*
**Deutsch:** Bedingung (Verzweigung)

## Kurz
Programmteil, der je nach Wahr/Falsch einen anderen Weg geht: `if`, `elseif`, `else`, `switch`.

> [!example] Für Kinder erklärt
> Eine Weggabelung: Wenn es regnet, Regenschirm – sonst Sonnenbrille.

## Details
- `if (…) { } elseif (…) { } else { }`
- `switch` für viele feste Werte
- Als falsch gelten `0`, `''`, `$null`, `$false`

## Beispiel
Maschine: **Schul-PC**
```powershell
if (Test-Path C:\Temp) { 'da' } else { 'fehlt' }
```

## Prüfungsfrage
Wann `switch` statt `if`?

> [!success]- Lösung
> Wenn ein Wert mit vielen festen Möglichkeiten verglichen wird.

## Siehe auch
[[Operator]] · [[Schleife]] · [[05_PS-Bedingungen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
