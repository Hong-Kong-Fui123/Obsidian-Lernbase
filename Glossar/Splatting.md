---
aliases:
  - "Splatting"
  - "@-Übergabe"
tags:
  - glossar
  - glossar/scripting
en: "Splatting"
de: "Parameter-Übergabe per Hashtable"
bereich: Scripting
---

**Splatting** = *Splatting*
**Deutsch:** Parameter-Übergabe per Hashtable

## Kurz
Parameter in einer Hashtable sammeln und mit `@name` an einen Befehl übergeben.

> [!example] Für Kinder erklärt
> Alle Zutaten vorher in eine Schüssel legen und die Schüssel auf einmal übergeben.

## Details
- Macht lange Befehle lesbar
- `@param` statt `$param` beim Aufruf
- Parameter können vorher bedingt ergänzt werden

## Beispiel
Maschine: **EXA-DC01**
```powershell
$p = @{ Name = 'Test'; Path = 'OU=Benutzer,DC=example,DC=com'; Enabled = $false }
New-ADUser @p
```

## Prüfungsfrage
Welches Zeichen steht beim Splatting vor dem Variablennamen?

> [!success]- Lösung
> `@`

## Siehe auch
[[Hashtable]] · [[Parameter]] · [[07_PS-Funktionen-Parameter]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
