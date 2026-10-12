---
aliases:
  - "Methode"
  - "Method"
tags:
  - glossar
  - glossar/scripting
en: "Method"
de: "Methode"
bereich: Scripting
---

**Methode** = *Method*
**Deutsch:** Methode

## Kurz
Aktion, die ein Objekt ausführen kann. Aufruf immer mit Klammern.

> [!example] Für Kinder erklärt
> Was die Figur auf der Sammelkarte kann: springen, rennen.

## Details
- Aufruf: `$objekt.Methode()`
- Beispiele: `.ToUpper()`, `.Replace('a','b')`, `.Stop()`
- Anzeigen: `Get-Member -MemberType Method`

## Beispiel
Maschine: **Schul-PC**
```powershell
'exa-dc01'.ToUpper()
(Get-Date).AddDays(-30)
```

## Prüfungsfrage
Woran erkennst du im Code eine Methode?

> [!success]- Lösung
> An den runden Klammern nach dem Namen.

## Siehe auch
[[Objekt]] · [[Eigenschaft]] · [[04_PS-Objekte-Pipeline]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
