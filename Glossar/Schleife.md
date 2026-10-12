---
aliases:
  - "Schleife"
  - "Loop"
  - "foreach"
  - "for"
  - "while"
tags:
  - glossar
  - glossar/scripting
en: "Loop"
de: "Schleife (Wiederholung)"
bereich: Scripting
---

**Schleife** = *Loop*
**Deutsch:** Schleife (Wiederholung)

## Kurz
Programmteil, der Befehle wiederholt: für jedes Element, eine feste Anzahl oder solange eine Bedingung gilt.

> [!example] Für Kinder erklärt
> Zähneputzen: einmal sagen, was zu tun ist, und es für jeden Zahn wiederholen.

## Details
- `foreach` – jedes Element einer Liste
- `for` – feste Anzahl
- `while` / `do…until` – solange/bis Bedingung
- `break` beendet, `continue` überspringt

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
foreach ($s in 'EXA-DC01','EXA-SRV01') { Test-Connection $s -Count 1 -Quiet }
```

## Prüfungsfrage
Welche Schleife läuft mindestens einmal?

> [!success]- Lösung
> `do … until` bzw. `do … while`.

## Siehe auch
[[Bedingung]] · [[Array]] · [[06_PS-Schleifen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
