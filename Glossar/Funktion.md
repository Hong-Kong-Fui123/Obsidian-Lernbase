---
aliases:
  - "Funktion"
  - "Function"
tags:
  - glossar
  - glossar/scripting
en: "Function"
de: "Funktion"
bereich: Scripting
---

**Funktion** = *Function*
**Deutsch:** Funktion

## Kurz
Benannter, wiederverwendbarer Codeblock, optional mit Parametern.

> [!example] Für Kinder erklärt
> Ein Rezept mit Namen: einmal aufschreiben, danach nur noch „Pfannkuchen backen!“ sagen.

## Details
- Definition: `function Verb-Nomen { param(…) … }`
- Aufruf ohne Klammern/Komma: `Get-X -Name a`
- Mehrere Funktionen → [[PS-Modul]]

## Beispiel
Maschine: **Schul-PC**
```powershell
function Get-Hallo { param([string]$Name) "Hallo $Name" }
Get-Hallo -Name Anna
```

## Prüfungsfrage
Warum Funktionen statt kopierten Codes?

> [!success]- Lösung
> Nur einmal schreiben und pflegen, Fehler nur an einer Stelle beheben.

## Siehe auch
[[Parameter]] · [[CmdletBinding]] · [[PS-Modul]] · [[07_PS-Funktionen-Parameter]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
