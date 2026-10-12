---
title: PowerShell – Operatoren
tags: [powershell, operatoren]
kapitel: "[[00_PS-Uebersicht]]"
---

# 03 PowerShell – Operatoren
← [[02_PS-Variablen-Datentypen]] · → [[04_PS-Objekte-Pipeline]]

**Inhalt:** [[#1 Rechnen]] · [[#2 Vergleichen]] · [[#3 Logik]] · [[#4 Text und Muster]] · [[#5 Zuweisen]] · [[#6 Sonstige]] · [[#7 Kontrollfragen]]

> [!example] Für Kinder erklärt
> [[Operator|Operatoren]] sind die **Zeichen zwischen den Dingen**: `+` zum Zusammenzählen, „ist gleich?“ zum Vergleichen. Wie in Mathe – nur dass der Computer bei Vergleichen nicht rechnet, sondern mit **Ja** (`True`) oder **Nein** (`False`) antwortet.

---

## 1 Rechnen

| Operator | Bedeutung | Beispiel | Ergebnis |
|---|---|---|---|
| `+` | plus / Text verbinden | `5 + 3` · `'EXA-' + 'DC01'` | `8` · `EXA-DC01` |
| `-` | minus | `10 - 4` | `6` |
| `*` | mal | `4 * 2` | `8` |
| `/` | geteilt | `7 / 2` | `3.5` |
| `%` | Rest | `7 % 2` | `1` |

```powershell
# Maschine: Schul-PC
1GB / 1MB                          # 1024 – Größeneinheiten eingebaut
[math]::Round(1234567890 / 1GB, 2) # 1.15
```

---

## 2 Vergleichen
**Wichtig:** PowerShell nutzt **nicht** `=`, `<`, `>` zum Vergleichen! (`=` weist zu, `>` leitet in Datei um.)

| Operator | Bedeutung | Beispiel | Ergebnis |
|---|---|---|---|
| `-eq` | gleich (equal) | `5 -eq 5` | True |
| `-ne` | ungleich (not equal) | `5 -ne 3` | True |
| `-gt` | größer (greater than) | `5 -gt 3` | True |
| `-ge` | größer gleich | `5 -ge 5` | True |
| `-lt` | kleiner (less than) | `2 -lt 3` | True |
| `-le` | kleiner gleich | `3 -le 2` | False |

- Standard: **ohne** Groß-/Kleinschreibung (`'A' -eq 'a'` → True)
- Mit Beachtung: `-ceq`, `-cne`, `-clike` …
- Merkhilfe: **e**qual, **n**ot **e**qual, **g**reater **t**han, **l**ess **t**han

---

## 3 Logik

| Operator | Bedeutung | Beispiel |
|---|---|---|
| `-and` | beide wahr | `($ram -ge 4) -and ($cpu -ge 2)` |
| `-or` | mindestens eins wahr | `($os -eq 'Server') -or ($os -eq 'Client')` |
| `-not` / `!` | umdrehen | `-not (Test-Path C:\Temp)` |

> [!example] Für Kinder erklärt
> `-and`: Du darfst raus, wenn die **Hausaufgaben fertig UND** das Zimmer aufgeräumt ist – beides muss stimmen.
> `-or`: Du bekommst Nachtisch, wenn du **Eis ODER** Pudding möchtest – eins reicht.

---

## 4 Text und Muster

| Operator | Bedeutung | Beispiel | Ergebnis |
|---|---|---|---|
| `-like` | Platzhalter `*` `?` | `'EXA-DC01' -like 'EXA-*'` | True |
| `-notlike` | Gegenteil | `'CON-DC' -notlike 'EXA-*'` | True |
| `-match` | regulärer Ausdruck | `'EXA-DC01' -match 'DC\d+'` | True |
| `-replace` | ersetzen (Regex) | `'EXA-DC01' -replace 'DC','SRV'` | EXA-SRV01 |
| `-split` | aufteilen | `'a;b;c' -split ';'` | a, b, c |
| `-join` | verbinden | `@('a','b') -join ', '` | a, b |
| `-contains` | Liste enthält Wert | `@(1,2,3) -contains 2` | True |
| `-in` | Wert in Liste | `2 -in @(1,2,3)` | True |

```powershell
# Maschine: Schul-PC
'Server: EXA-DC01' -match 'EXA-(\w+)'
$Matches[1]            # DC01 – Treffer der Klammer
```

---

## 5 Zuweisen

| Operator | Bedeutung | Beispiel |
|---|---|---|
| `=` | zuweisen | `$x = 5` |
| `+=` | dazuzählen / anhängen | `$x += 1` · `$liste += 'neu'` |
| `-=`, `*=`, `/=` | rechnen und zuweisen | `$x *= 2` |
| `++` / `--` | um 1 erhöhen/verringern | `$i++` |

---

## 6 Sonstige

| Operator | Bedeutung |
|---|---|
| `\|` | Pipeline → [[04_PS-Objekte-Pipeline]] |
| `>` / `>>` | Ausgabe in Datei (überschreiben / anhängen) |
| `..` | Bereich `1..5` |
| `-is` | Typprüfung `$x -is [int]` |
| `-as` | Umwandlung ohne Fehler `'5' -as [int]` |
| `.` (Dot-Sourcing) | Skript im aktuellen Bereich laden → [[10_PS-Skripte-Module-Sicherheit]] |
| `&` | Befehl/Skriptblock ausführen `& 'C:\Pfad mit Leerzeichen\x.exe'` |
| `? :` / `??` | nur PowerShell 7: Kurzform für if / Ersatzwert |

---

## 7 Kontrollfragen
1. Warum ist `if ($a = 5)` ein Fehler?
2. Prüfe, ob `$server` mit `EXA-` beginnt **und** `$ram` mindestens 4 ist.
3. Ergebnis von `'Lab;Test;Prod' -split ';' | Select-Object -Last 1`?

> [!success]- Lösungen
> 1. `=` weist zu statt zu vergleichen. Richtig: `-eq`.
> 2. `($server -like 'EXA-*') -and ($ram -ge 4)`
> 3. `Prod`
