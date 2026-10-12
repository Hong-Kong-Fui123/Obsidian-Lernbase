---
aliases:
  - "Scriptblock"
  - "Skriptblock"
  - "ScriptBlock"
tags:
  - glossar
  - glossar/scripting
en: "Script Block"
de: "Skriptblock"
bereich: Scripting
---

**Scriptblock** = *Script Block*
**Deutsch:** Skriptblock

## Kurz
Code in geschweiften Klammern `{ }`, der als Einheit weitergegeben und später ausgeführt wird.

> [!example] Für Kinder erklärt
> Ein verschlossener Umschlag mit Anweisungen, den jemand anders öffnet und ausführt.

## Details
- In `Where-Object { … }`, `ForEach-Object { … }`, `Invoke-Command -ScriptBlock { … }`
- Ausführen: `& $block`
- Remote: lokale Variablen mit `$using:`

## Beispiel
Maschine: **Schul-PC**
```powershell
$b = { param($x) $x * 2 }
& $b 21
```

## Prüfungsfrage
Warum kennt ein Scriptblock bei `Invoke-Command` lokale Variablen nicht?

> [!success]- Lösung
> Er läuft auf dem anderen Computer in einer eigenen Sitzung.

## Siehe auch
[[PS-Remoting]] · [[PS-Pipeline]] · [[11_PS-Remoting]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
