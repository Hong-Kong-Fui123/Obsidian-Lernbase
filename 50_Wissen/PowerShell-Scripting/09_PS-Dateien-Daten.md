---
title: PowerShell – Dateien und Daten
tags: [powershell, dateien, csv, json]
kapitel: "[[00_PS-Uebersicht]]"
---

# 09 PowerShell – Dateien und Daten
← [[08_PS-Fehlerbehandlung-Debugging]] · → [[10_PS-Skripte-Module-Sicherheit]]

**Inhalt:** [[#1 Pfade]] · [[#2 Ordner und Dateien]] · [[#3 Text lesen und schreiben]] · [[#4 CSV]] · [[#5 JSON]] · [[#6 XML]] · [[#7 Kodierung]] · [[#8 Kontrollfragen]]

> [!example] Für Kinder erklärt
> Dateien sind das **Gedächtnis** des Skripts. Was in einer Variable steht, ist weg, wenn das Skript endet – wie etwas, das du nur im Kopf hast. Was in einer Datei steht, ist wie im **Heft aufgeschrieben**: morgen noch da.

---

## 1 Pfade

| Befehl | Zweck | Beispiel |
|---|---|---|
| `Join-Path` | Pfade sicher zusammensetzen | `Join-Path $PSScriptRoot 'daten.csv'` |
| `Test-Path` | existiert? | `Test-Path C:\Skripte` |
| `Split-Path` | Ordner/Dateiname trennen | `Split-Path $pfad -Leaf` |
| `Resolve-Path` | relativ → absolut | `Resolve-Path .\x.ps1` |
| `$PSScriptRoot` | Ordner des Skripts | Dateien neben dem Skript finden |

---

## 2 Ordner und Dateien
```powershell
# Maschine: Schul-PC
New-Item -Path C:\Skripte\log -ItemType Directory -Force    # -Force: kein Fehler, falls vorhanden
New-Item -Path C:\Skripte\test.txt -ItemType File
Copy-Item  C:\Skripte\test.txt C:\Temp\ -Force
Move-Item  C:\Temp\test.txt C:\Temp\test_alt.txt
Remove-Item C:\Temp\test_alt.txt -WhatIf                    # erst prüfen!

# Suchen
Get-ChildItem C:\Skripte -Recurse -Filter *.ps1
Get-ChildItem C:\Windows\Logs -Recurse -File |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
```

---

## 3 Text lesen und schreiben

| Cmdlet | Wirkung |
|---|---|
| `Get-Content` | Datei zeilenweise lesen (Array) |
| `Get-Content -Raw` | als ein großer Text |
| `Get-Content -Tail 20 -Wait` | letzte 20 Zeilen, live mitlesen (wie `tail -f`) |
| `Set-Content` | schreiben (überschreibt) |
| `Add-Content` | anhängen |
| `Out-File` | Ausgabe in Datei |
| `Select-String` | in Dateien suchen (wie `grep`/`findstr`) |

```powershell
# Maschine: Schul-PC
Set-Content C:\Temp\server.txt -Value 'EXA-DC01','EXA-SRV01','EXA-SRV02' -Encoding UTF8
$liste = Get-Content C:\Temp\server.txt
$liste.Count                                           # 3
Add-Content C:\Temp\server.txt 'EXA-WEB01'
Select-String -Path C:\Windows\Logs\CBS\CBS.log -Pattern 'error' | Select-Object -First 5
```

---

## 4 CSV
Tabellen, die Excel öffnen kann. Ideal für Massenänderungen (Benutzer, Rechner).

`C:\Skripte\benutzer.csv`
```csv
Vorname;Nachname;Abteilung
Anna;Schmidt;IT
Jörg;Müller;Vertrieb
```

```powershell
# Maschine: Schul-PC
$daten = Import-Csv C:\Skripte\benutzer.csv -Delimiter ';' -Encoding UTF8
$daten | Format-Table
$daten[0].Vorname                                      # Anna
foreach ($z in $daten) { "$($z.Vorname) $($z.Nachname) – $($z.Abteilung)" }

# Exportieren
Get-Service | Select-Object Name, Status |
    Export-Csv C:\Temp\dienste.csv -NoTypeInformation -Delimiter ';' -Encoding UTF8
```
`-Delimiter ';'`: Deutsches Excel nutzt Semikolon. `-NoTypeInformation`: keine Typzeile (in PS 7 Standard).

---

## 5 JSON
Format für Konfigurationen und [[API|APIs]].
`C:\Skripte\config.json`
```json
{
  "Domaene": "example.com",
  "Server": ["EXA-DC01", "EXA-SRV01"],
  "LogTage": 30
}
```
```powershell
# Maschine: Schul-PC
$cfg = Get-Content C:\Skripte\config.json -Raw | ConvertFrom-Json
$cfg.Domaene
$cfg.Server[1]
$cfg.LogTage = 14
$cfg | ConvertTo-Json -Depth 5 | Set-Content C:\Skripte\config.json -Encoding UTF8
```

---

## 6 XML
```powershell
# Maschine: Schul-PC
[xml]$x = '<lab><server name="EXA-DC01" rolle="DC"/><server name="EXA-SRV01" rolle="CA"/></lab>'
$x.lab.server | Select-Object name, rolle

# Maschine: EXA-SRV01 (IIS installiert) – echte XML-Konfiguration lesen
[xml]$iis = Get-Content C:\Windows\System32\inetsrv\config\applicationHost.config
$iis.configuration.'system.applicationHost'.sites.site | Select-Object name, id
```
Objekte speichern und 1:1 wiederherstellen: `Export-Clixml` / `Import-Clixml` (auch für verschlüsselte Zugangsdaten, siehe [[10_PS-Skripte-Module-Sicherheit#6 Zugangsdaten sicher speichern]]).

---

## 7 Kodierung

| Problem | Ursache | Lösung |
|---|---|---|
| `JÃ¶rg` statt `Jörg` | Datei UTF-8, gelesen als ANSI | `-Encoding UTF8` |
| Umlaute im Skript kaputt (5.1) | `.ps1` ohne BOM gespeichert | Skript als **UTF-8 mit BOM** speichern |
| Excel zeigt alles in einer Spalte | Komma statt Semikolon | `-Delimiter ';'` |

> [!note] Version
> PowerShell 5.1: `-Encoding UTF8` schreibt mit BOM. PowerShell 7: Standard ist UTF-8 ohne BOM.

---

## 8 Kontrollfragen
1. Unterschied `Set-Content` und `Add-Content`?
2. Warum `Join-Path` statt `"$ordner\$datei"`?
3. Lies `server.txt` ein und pinge jeden Server einmal.

> [!success]- Lösungen
> 1. `Set-Content` überschreibt, `Add-Content` hängt an.
> 2. Kümmert sich um fehlende/doppelte `\` und funktioniert auch mit Laufwerken anderer Provider.
> 3.
> ```powershell
> Get-Content C:\Temp\server.txt | ForEach-Object { Test-Connection $_ -Count 1 -Quiet }
> ```
