---
title: PowerShell – Variablen und Datentypen
tags: [powershell, variablen, datentypen]
kapitel: "[[00_PS-Uebersicht]]"
---

# 02 PowerShell – Variablen und Datentypen
← [[01_PS-Grundlagen]] · → [[03_PS-Operatoren]]

**Inhalt:** [[#1 Variablen]] · [[#2 Datentypen]] · [[#3 Text (Strings)]] · [[#4 Arrays]] · [[#5 Hashtables]] · [[#6 Automatische Variablen]] · [[#7 Gültigkeitsbereich]] · [[#8 Kontrollfragen]]

---

## 1 Variablen

> [!example] Für Kinder erklärt
> Eine **Variable** ist wie ein **Schuhkarton mit Namensschild**. Auf das Schild schreibst du z. B. `$alter`, in den Karton legst du `10`. Später fragst du nur „Was ist im Karton `$alter`?“ und bekommst `10`. Du kannst den Inhalt jederzeit austauschen – das Schild bleibt.

```powershell
# Maschine: Schul-PC
$name  = 'EXA-DC01'          # Text in den Karton legen
$alter = 10                  # Zahl
$name                        # Inhalt anzeigen
$alter = $alter + 1          # Inhalt ändern → 11
Remove-Variable alter        # Karton wegwerfen
```

Regeln:
- Name beginnt mit `$`, danach Buchstaben, Zahlen, `_`
- Groß-/Kleinschreibung egal: `$Name` = `$name`
- Sprechende Namen: `$serverListe` statt `$x`

---

## 2 Datentypen
Ein [[Datentyp]] sagt, **was für ein Inhalt** im Karton liegt.

| Typ | Beispiel | Erklärung |
|---|---|---|
| `[string]` | `'Hallo'` | Text |
| `[int]` | `42` | ganze Zahl |
| `[double]` | `3.14` | Kommazahl (Punkt!) |
| `[bool]` | `$true`, `$false` | wahr/falsch |
| `[datetime]` | `Get-Date` | Datum und Uhrzeit |
| `[array]` | `@(1,2,3)` | Liste → [[Array]] |
| `[hashtable]` | `@{Name='DC01'}` | Schlüssel-Wert-Tabelle → [[Hashtable]] |
| `[ipaddress]` | `'192.168.10.10'` | IP-Adresse (mit Prüfung) |

```powershell
# Maschine: Schul-PC
$zahl = 5
$zahl.GetType().Name         # Int32
[int]$port = '8080'          # Text wird in Zahl umgewandelt
[int]$port = 'abc'           # Fehler – passt nicht in den Karton
[ipaddress]'192.168.10.300'  # Fehler – keine gültige IP
```

> [!example] Für Kinder erklärt
> Manche Kartons haben eine **Form**: In einen Eierkarton passen nur Eier. `[int]` ist ein Karton nur für ganze Zahlen. Versuchst du, ein Wort hineinzulegen, beschwert sich der Computer.

---

## 3 Text (Strings)

| Schreibweise | Wirkung |
|---|---|
| `'Text $name'` | einfache Anführungszeichen: **genau so** ausgeben |
| `"Text $name"` | doppelte: Variablen werden **eingesetzt** |
| `"Dienst: $($svc.Name)"` | Eigenschaften mit `$( )` einsetzen |
| `` "Zeile1`nZeile2" `` | `` `n `` = neue Zeile, `` `t `` = Tab |

```powershell
# Maschine: Schul-PC
$server = 'EXA-DC01'
'Server: $server'                  # Server: $server
"Server: $server"                  # Server: EXA-DC01
"Heute: $((Get-Date).ToString('dd.MM.yyyy'))"

# Nützliche Methoden
$server.ToLower()                  # exa-dc01
$server.Length                     # 8
$server.Replace('DC','SRV')        # EXA-SRV01
$server.Split('-')                 # EXA / DC01
$server -like 'EXA-*'              # True
'{0} hat {1} GB' -f 'EXA-DC01', 4  # Format-Operator
```

Mehrzeiliger Text (Here-String):
```powershell
$text = @"
Server: $server
Datum : $(Get-Date)
"@
```

---

## 4 Arrays
Ein [[Array]] ist eine **Liste** mehrerer Werte.

> [!example] Für Kinder erklärt
> Ein Array ist wie ein **Eierkarton mit nummerierten Fächern**. Das erste Fach hat die Nummer **0** (nicht 1!). So findest du jedes Ei über seine Fachnummer.

```powershell
# Maschine: Schul-PC
$server = @('EXA-DC01', 'EXA-SRV01', 'EXA-SRV02')
$server[0]            # EXA-DC01 (erstes Element)
$server[-1]           # EXA-SRV02 (letztes)
$server.Count         # 3
$server += 'EXA-WEB01'          # hinzufügen (erzeugt neues Array)
$server -contains 'EXA-DC01'    # True
$zahlen = 1..10                 # Bereich 1 bis 10
```

Für viele Einträge schneller:
```powershell
$liste = [System.Collections.Generic.List[string]]::new()
$liste.Add('EXA-DC01')
```

---

## 5 Hashtables
Eine [[Hashtable]] speichert **Schlüssel = Wert**-Paare.

> [!example] Für Kinder erklärt
> Eine Hashtable ist wie ein **Telefonbuch**: Du suchst nicht nach Fachnummer, sondern nach einem **Namen** (Schlüssel) und bekommst die passende **Nummer** (Wert).

```powershell
# Maschine: Schul-PC
$ip = @{
    'EXA-DC01'  = '192.168.10.10'
    'EXA-SRV01' = '192.168.10.21'
}
$ip['EXA-DC01']                 # 192.168.10.10
$ip.'EXA-SRV01'                 # Punkt-Schreibweise
$ip['EXA-WEB01'] = '192.168.10.30'   # hinzufügen
$ip.Keys                        # alle Schlüssel
$ip.ContainsKey('EXA-DC01')     # True

# Geordnet und als Objekt (für Berichte)
$info = [ordered]@{ Name = 'EXA-DC01'; Rolle = 'DC'; RAM = 2 }
[pscustomobject]$info
```

---

## 6 Automatische Variablen

| Variable | Inhalt |
|---|---|
| `$_` / `$PSItem` | aktuelles Objekt in der Pipeline |
| `$true`, `$false`, `$null` | wahr, falsch, nichts |
| `$Error` | Liste der letzten Fehler |
| `$LASTEXITCODE` | Rückgabewert externer Programme |
| `$?` | war der letzte Befehl erfolgreich? |
| `$PSScriptRoot` | Ordner des laufenden Skripts |
| `$env:COMPUTERNAME` | Computername (Umgebungsvariable) |
| `$HOME`, `$PROFILE` | Benutzerordner, Profilpfad |

---

## 7 Gültigkeitsbereich
Variablen in einer [[Funktion]] sind **außen nicht sichtbar** (lokaler Bereich).

```powershell
# Maschine: Schul-PC
$x = 1
function Test-Bereich { $x = 99; "innen: $x" }
Test-Bereich        # innen: 99
"außen: $x"         # außen: 1
```
`$script:x` = Variable für das ganze Skript, `$global:x` = für die ganze Sitzung (sparsam nutzen).

---

## 8 Kontrollfragen
1. Was gibt `"Server: $name"` aus, was `'Server: $name'`?
2. `$liste = @('a','b','c')` – wie bekommst du `b`?
3. Wann Array, wann Hashtable?

> [!success]- Lösungen
> 1. Doppelte Anführungszeichen setzen den Wert ein, einfache geben den Text wörtlich aus.
> 2. `$liste[1]` (Zählung beginnt bei 0).
> 3. Array: Reihenfolge/Liste gleicher Dinge. Hashtable: Zugriff über einen Namen (Schlüssel).
