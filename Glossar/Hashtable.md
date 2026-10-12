---
aliases:
  - "Hashtable"
  - "Hash-Tabelle"
  - "Dictionary"
  - "Schlüssel-Wert"
tags:
  - glossar
  - glossar/scripting
en: "Hash Table"
de: "Schlüssel-Wert-Tabelle"
bereich: Scripting
---

**Hashtable** = *Hash Table*
**Deutsch:** Schlüssel-Wert-Tabelle

## Kurz
Sammlung von Schlüssel-Wert-Paaren; Zugriff über den Schlüssel statt über eine Position.

> [!example] Für Kinder erklärt
> Ein Telefonbuch: Du suchst den Namen und bekommst die Nummer.

## Details
- Anlegen: `@{ Name = 'DC01'; IP = '10.0.0.1' }`
- Zugriff: `$h['Name']` oder `$h.Name`
- Grundlage für [[Splatting]] und `[pscustomobject]`

## Beispiel
Maschine: **Schul-PC**
```powershell
$ip = @{ 'EXA-DC01' = '192.168.10.10' }
$ip['EXA-DC01']
```

## Prüfungsfrage
Wann Hashtable statt Array?

> [!success]- Lösung
> Wenn man Werte über einen Namen nachschlagen will.

## Siehe auch
[[Array]] · [[Splatting]] · [[02_PS-Variablen-Datentypen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
