---
title: PowerShell – Aufgaben
tags: [powershell, aufgabe]
kapitel: "[[00_PS-Uebersicht]]"
---

# 14 PowerShell – Aufgaben
← [[13_PS-Stil-Best-Practices]] · → [[15_PS-Klausur]]

Erst selbst versuchen, dann Hinweis, dann Lösung. Stufen: ⭐ leicht · ⭐⭐ mittel · ⭐⭐⭐ schwer

---

### A1 ⭐ – Hilfe benutzen
Finde ohne Internet heraus, mit welchem Cmdlet man Prozesse beendet und welcher Parameter einen Prozess per Name auswählt.
> [!hint]- Hinweis
> Verb für „beenden“ bei Diensten war `Stop`. Nomen: `Process`.

> [!success]- Lösung
> ```powershell
> # Maschine: Schul-PC
> Get-Command -Noun Process          # Stop-Process
> Get-Help Stop-Process -Parameter Name
> ```

### A2 ⭐ – Variablen
Lege `$vorname` und `$nachname` an und gib „Willkommen, Vorname Nachname!“ aus.
> [!success]- Lösung
> ```powershell
> $vorname = 'Anna'; $nachname = 'Schmidt'
> "Willkommen, $vorname $nachname!"
> ```

### A3 ⭐ – Array
Erstelle ein Array mit vier Servernamen. Gib den zweiten und den letzten aus sowie die Anzahl.
> [!success]- Lösung
> ```powershell
> $s = 'EXA-DC01','EXA-SRV01','EXA-SRV02','EXA-WEB01'
> $s[1]; $s[-1]; $s.Count
> ```

### A4 ⭐⭐ – Pipeline
Zeige die 5 Prozesse mit dem höchsten Arbeitsspeicher, Spalten Name und RAM in MB (gerundet).
> [!hint]- Hinweis
> `Sort-Object -Descending`, berechnete Eigenschaft mit `@{Name=…; Expression={…}}`.

> [!success]- Lösung
> ```powershell
> # Maschine: Schul-PC
> Get-Process | Sort-Object WS -Descending | Select-Object -First 5 Name,
>   @{Name='RAM_MB'; Expression={ [math]::Round($_.WS / 1MB) }}
> ```

### A5 ⭐⭐ – Bedingung
Prüfe, ob der Ordner `C:\Skripte\log` existiert. Wenn nicht, lege ihn an und gib „angelegt“ aus, sonst „vorhanden“.
> [!success]- Lösung
> ```powershell
> if (Test-Path C:\Skripte\log) { 'vorhanden' }
> else { New-Item C:\Skripte\log -ItemType Directory | Out-Null; 'angelegt' }
> ```

### A6 ⭐⭐ – Schleife
Lege mit einer Schleife die leeren Dateien `test01.txt` bis `test10.txt` in `C:\Temp\Uebung` an (führende Null!).
> [!hint]- Hinweis
> Format-Operator: `'{0:D2}' -f 3` → `03`

> [!success]- Lösung
> ```powershell
> New-Item C:\Temp\Uebung -ItemType Directory -Force | Out-Null
> for ($i = 1; $i -le 10; $i++) {
>     New-Item ("C:\Temp\Uebung\test{0:D2}.txt" -f $i) -ItemType File -Force | Out-Null
> }
> ```

### A7 ⭐⭐ – switch
Lies mit `Read-Host` eine Zahl 1–3 ein: 1 = Uhrzeit, 2 = Computername, 3 = freier Platz auf C:. Alles andere: „Ungültig“.
> [!success]- Lösung
> ```powershell
> switch (Read-Host 'Auswahl 1-3') {
>     '1' { Get-Date -Format 'HH:mm' }
>     '2' { $env:COMPUTERNAME }
>     '3' { '{0:N1} GB' -f ((Get-PSDrive C).Free / 1GB) }
>     default { 'Ungültig' }
> }
> ```

### A8 ⭐⭐ – Funktion
Schreibe `Test-Port` mit Pflichtparameter `ComputerName` und `Port` (1–65535, Standard 3389), Rückgabe True/False.
> [!success]- Lösung
> ```powershell
> function Test-Port {
>     [CmdletBinding()]
>     param(
>         [Parameter(Mandatory)][string]$ComputerName,
>         [ValidateRange(1,65535)][int]$Port = 3389
>     )
>     Test-NetConnection -ComputerName $ComputerName -Port $Port -InformationLevel Quiet
> }
> ```

### A9 ⭐⭐ – Fehlerbehandlung
Warum gibt dieser Code keine Meldung „Fehler!“ aus? Repariere ihn.
```powershell
try { Get-Item C:\gibtsnicht } catch { 'Fehler!' }
```
> [!success]- Lösung
> Nicht abbrechender Fehler → `catch` greift nicht. Richtig: `Get-Item C:\gibtsnicht -ErrorAction Stop`.

### A10 ⭐⭐ – CSV
Exportiere alle **automatisch startenden, aber gestoppten** Dienste als CSV (Semikolon, UTF-8) nach `C:\Temp\dienste.csv`.
> [!success]- Lösung
> ```powershell
> Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' } |
>   Select-Object Name, DisplayName, Status |
>   Export-Csv C:\Temp\dienste.csv -NoTypeInformation -Delimiter ';' -Encoding UTF8
> ```

### A11 ⭐⭐⭐ – Remoting
Ermittle von EXA-DC01, EXA-SRV01, EXA-SRV02 die Anzahl installierter Updates und die letzte Startzeit in **einem** Befehl vom Hyper-V-Host aus.
> [!success]- Lösung
> ```powershell
> # Maschine: Hyper-V-Host
> Invoke-Command -ComputerName EXA-DC01, EXA-SRV01, EXA-SRV02 -ScriptBlock {
>     [pscustomobject]@{
>         Updates   = (Get-HotFix).Count
>         LetzterStart = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
>     }
> } | Select-Object PSComputerName, Updates, LetzterStart
> ```

### A12 ⭐⭐⭐ – Inaktive Konten
Skript `Get-InaktiveBenutzer.ps1` für EXA-DC01: Parameter `-Tage` (Standard 90), listet aktivierte Benutzer, die sich länger nicht angemeldet haben, mit Name, SamAccountName, LetzteAnmeldung. Mit `-Deaktivieren` (Schalter) und `-WhatIf`-Unterstützung sollen sie deaktiviert werden.
> [!hint]- Hinweis
> `Search-ADAccount -AccountInactive -TimeSpan (New-TimeSpan -Days $Tage) -UsersOnly`, Parameter vom Typ `[switch]`, `$PSCmdlet.ShouldProcess()`.

> [!success]- Lösung
> ```powershell
> [CmdletBinding(SupportsShouldProcess)]
> param(
>     [ValidateRange(1,3650)][int]$Tage = 90,
>     [switch]$Deaktivieren
> )
> $konten = Search-ADAccount -AccountInactive -TimeSpan (New-TimeSpan -Days $Tage) -UsersOnly |
>           Where-Object Enabled
> foreach ($k in $konten) {
>     if ($Deaktivieren -and $PSCmdlet.ShouldProcess($k.SamAccountName, 'Deaktivieren')) {
>         Disable-ADAccount -Identity $k
>     }
>     [pscustomobject]@{
>         Name             = $k.Name
>         SamAccountName   = $k.SamAccountName
>         LetzteAnmeldung  = $k.LastLogonDate
>     }
> }
> ```

### A13 ⭐⭐⭐ – Fehler finden
Finde **fünf** Fehler oder Stilprobleme:
```powershell
function backup($quelle, $ziel)
{
  $pw = "Admin123!"
  gci $quelle | % { copy $_.FullName $ziel }
  if ($ziel = "") { Write-Host "kein Ziel" }
  Write-Host "Fertig"
}
backup("C:\Daten", "D:\Backup")
```
> [!success]- Lösung
> - Name ohne [[Verb-Nomen]] → `Start-Backup`/`Backup-LabDaten`
> - Klartext-Passwort im Code
> - Aliase `gci`, `%`, `copy`
> - `if ($ziel = "")` weist zu statt zu prüfen → `[string]::IsNullOrEmpty($ziel)`; Prüfung außerdem erst **nach** dem Kopieren
> - Aufruf mit Klammern und Komma → `Start-Backup -Quelle C:\Daten -Ziel D:\Backup`
> - Kein `param()` mit Typen/Validierung, keine Fehlerbehandlung, kein `-WhatIf`

### A14 ⭐⭐⭐ – Für Kinder erklären
Erkläre einem 10-jährigen Kind in je **einem** Satz: Variable, Schleife, Bedingung, Funktion. Nutze eigene Vergleiche, nicht die aus dem Kapitel.
> [!success]- Beispiel-Lösung
> - Variable: ein beschrifteter Becher, in den man etwas hineinlegen und wieder austauschen kann.
> - Schleife: Treppensteigen – derselbe Schritt, bis du oben bist.
> - Bedingung: Ampel – bei Rot stehen bleiben, bei Grün gehen.
> - Funktion: ein Knopf an der Spülmaschine, der viele Schritte auf einmal auslöst.
