---
aliases:
  - "Parameter"
  - "Argument"
  - "param"
tags:
  - glossar
  - glossar/scripting
en: "Parameter"
de: "Parameter (Übergabewert)"
bereich: Scripting
---

**Parameter** = *Parameter*
**Deutsch:** Parameter (Übergabewert)

## Kurz
Benannter Eingabewert für eine Funktion oder ein Skript.

> [!example] Für Kinder erklärt
> Die Zutaten, die man dem Rezept jedes Mal mitgibt.

## Details
- Block `param( … )` am Anfang
- Pflicht: `[Parameter(Mandatory)]`
- Prüfung: `ValidateSet`, `ValidateRange`, `ValidateScript`
- Schalter: `[switch]$Force`

## Beispiel
Maschine: **Schul-PC**
```powershell
param(
    [Parameter(Mandatory)][ValidateSet('DC','WEB')][string]$Rolle
)
```

## Prüfungsfrage
Was bewirkt `[ValidateRange(1,65535)]`?

> [!success]- Lösung
> Nur Werte von 1 bis 65535 sind erlaubt, sonst Fehler vor dem Start.

## Siehe auch
[[Funktion]] · [[Splatting]] · [[07_PS-Funktionen-Parameter]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
