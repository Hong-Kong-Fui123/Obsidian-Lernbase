---
title: PowerShell – Klausur
tags: [powershell, klausur]
kapitel: "[[00_PS-Uebersicht]]"
---

# 15 PowerShell – Klausur
← [[14_PS-Aufgaben]] · ↑ [[00_PS-Uebersicht]]

**Zeit: 60 Min · 60 Punkte · Hilfsmittel: Get-Help**
Bestanden ab 30 Punkten. Bei jedem Befehl Maschine angeben.

---

## Teil A – Grundlagen (16 P)
1. Nenne die drei Befehle, mit denen du dir in PowerShell selbst hilfst, und ihren Zweck. *(3 P)*
2. Erkläre den Unterschied zwischen `'Server: $s'` und `"Server: $s"`. *(2 P)*
3. Welche Operatoren prüfen „größer als“, „ungleich“ und „Muster mit Platzhalter“? *(3 P)*
4. Was ist ein Objekt? Nenne den Unterschied zwischen Eigenschaft und Methode mit je einem Beispiel. *(4 P)*
5. Was bedeutet „Filtern links, Formatieren rechts“? *(2 P)*
6. Nenne zwei Ausführungsrichtlinien und ihre Bedeutung. *(2 P)*

## Teil B – Code lesen (14 P)
7. Was gibt der Code aus? *(3 P)*
```powershell
$summe = 0
foreach ($z in 1..5) { if ($z % 2 -eq 1) { $summe += $z } }
$summe
```
8. Warum wird hier nie „Fehler“ ausgegeben, obwohl der Ordner fehlt? Korrigiere. *(3 P)*
```powershell
try { Get-ChildItem D:\gibtsnicht } catch { 'Fehler' }
```
9. Was ist an diesem Aufruf falsch? `Test-Port('EXA-DC01', 389)` *(2 P)*
10. Erkläre jede Zeile: *(6 P)*
```powershell
Get-Service |
  Where-Object Status -eq 'Stopped' |
  Sort-Object Name |
  Select-Object -First 3 Name, StartType
```

## Teil C – Code schreiben (30 P)
11. Schreibe eine `for`-Schleife, die `PC01` bis `PC05` ausgibt. *(3 P)*
12. Schreibe eine erweiterte Funktion `Get-OrdnerGroesse` mit Pflichtparameter `Pfad` (muss existieren), die die Größe in MB (2 Nachkommastellen) als Objekt mit `Pfad` und `GroesseMB` zurückgibt. *(10 P)*
13. Schreibe ein Skript für EXA-DC01, das eine CSV `C:\Skripte\daten\gruppen.csv` (Spalten `Gruppe;Beschreibung`, Semikolon) liest und für jede Zeile eine globale Sicherheitsgruppe in `OU=Gruppen,DC=example,DC=com` anlegt, sofern sie noch nicht existiert. Mit Fehlerbehandlung und `-WhatIf`-Unterstützung. *(12 P)*
14. Wie führst du `Get-Date` gleichzeitig auf EXA-SRV01 und EXA-SRV02 vom Hyper-V-Host aus? *(2 P)*
15. Erkläre einem 10-jährigen Kind, was eine Schleife ist. *(3 P)*

---

> [!success]- Lösungen
> **A**
> 1. `Get-Command` (Befehle finden) · `Get-Help` (Benutzung) · `Get-Member` (Eigenschaften/Methoden eines Ergebnisses)
> 2. Einfache Anführungszeichen geben wörtlich aus, doppelte setzen den Variablenwert ein.
> 3. `-gt` · `-ne` · `-like`
> 4. Objekt = Datensatz mit Eigenschaften und Methoden. Eigenschaft = Wert (`$svc.Status`), Methode = Aktion (`$svc.Stop()`).
> 5. Erst früh in der Pipeline filtern (weniger Daten, schneller), Formatierung (`Format-*`) ganz am Ende, weil danach keine Weiterverarbeitung möglich ist.
> 6. z. B. `RemoteSigned` (lokale Skripte ja, heruntergeladene nur signiert), `AllSigned` (nur signierte), `Restricted` (keine Skripte).
>
> **B**
> 7. `9` (1 + 3 + 5)
> 8. Nicht abbrechender Fehler. `Get-ChildItem D:\gibtsnicht -ErrorAction Stop`
> 9. Klammern/Komma übergeben ein Array an den ersten Parameter. Richtig: `Test-Port -ComputerName EXA-DC01 -Port 389`
> 10. Alle Dienste holen → nur gestoppte durchlassen → nach Name sortieren → die ersten 3 mit Spalten Name und StartType ausgeben.
>
> **C**
> 11. `for ($i = 1; $i -le 5; $i++) { 'PC{0:D2}' -f $i }`
> 12.
> ```powershell
> function Get-OrdnerGroesse {
>     [CmdletBinding()]
>     param(
>         [Parameter(Mandatory)]
>         [ValidateScript({ Test-Path $_ -PathType Container })]
>         [string]$Pfad
>     )
>     $summe = (Get-ChildItem $Pfad -Recurse -File -ErrorAction SilentlyContinue |
>               Measure-Object Length -Sum).Sum
>     [pscustomobject]@{
>         Pfad      = $Pfad
>         GroesseMB = [math]::Round($summe / 1MB, 2)
>     }
> }
> ```
> 13.
> ```powershell
> # Maschine: EXA-DC01
> [CmdletBinding(SupportsShouldProcess)]
> param(
>     [ValidateScript({ Test-Path $_ })]
>     [string]$CsvPfad = 'C:\Skripte\daten\gruppen.csv',
>     [string]$OU = 'OU=Gruppen,DC=example,DC=com'
> )
> $ErrorActionPreference = 'Stop'
> foreach ($z in Import-Csv $CsvPfad -Delimiter ';' -Encoding UTF8) {
>     try {
>         if (Get-ADGroup -Filter "Name -eq '$($z.Gruppe)'") {
>             Write-Warning "$($z.Gruppe) existiert bereits"
>         }
>         elseif ($PSCmdlet.ShouldProcess($z.Gruppe, 'Gruppe anlegen')) {
>             New-ADGroup -Name $z.Gruppe -Description $z.Beschreibung `
>                 -GroupScope Global -GroupCategory Security -Path $OU
>             "$($z.Gruppe) angelegt"
>         }
>     }
>     catch { Write-Error "$($z.Gruppe): $($_.Exception.Message)" }
> }
> ```
> 14. `Invoke-Command -ComputerName EXA-SRV01, EXA-SRV02 -ScriptBlock { Get-Date }` (Maschine: Hyper-V-Host)
> 15. Eigener kindgerechter Vergleich, z. B.: „Eine Schleife ist wie Treppensteigen: Du machst immer wieder denselben Schritt, bis du oben angekommen bist.“
