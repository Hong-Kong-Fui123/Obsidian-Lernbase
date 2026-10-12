---
title: PowerShell – Funktionen und Parameter
tags: [powershell, funktionen, parameter]
kapitel: "[[00_PS-Uebersicht]]"
---

# 07 PowerShell – Funktionen und Parameter
← [[06_PS-Schleifen]] · → [[08_PS-Fehlerbehandlung-Debugging]]

**Inhalt:** [[#1 Idee]] · [[#2 Einfache Funktion]] · [[#3 Parameter]] · [[#4 Parameter prüfen (Validierung)]] · [[#5 Erweiterte Funktion (CmdletBinding)]] · [[#6 Pipeline-Eingabe]] · [[#7 Rückgabewerte]] · [[#8 Hilfe einbauen]] · [[#9 Splatting]] · [[#10 Kontrollfragen]]

---

## 1 Idee

> [!example] Für Kinder erklärt
> Eine [[Funktion]] ist wie ein **Rezept mit Namen**: „Pfannkuchen backen“. Du schreibst die Schritte **einmal** auf. Danach sagst du nur noch „Pfannkuchen backen!“ – und alles läuft ab. **Parameter** sind die Zutaten, die du jedes Mal mitgibst: „Pfannkuchen backen mit **3** Eiern und **Blaubeeren**“.

Vorteile:
- Code nur **einmal** schreiben, oft benutzen
- Fehler nur an **einer** Stelle beheben
- Skript wird in kleine, verständliche Bausteine zerlegt

---

## 2 Einfache Funktion
```powershell
# Maschine: Schul-PC
function Get-Begruessung {
    "Hallo, heute ist $((Get-Date).DayOfWeek)."
}

Get-Begruessung     # Aufruf – ohne Klammern!
```
Namen nach [[Verb-Nomen]]-Regel mit erlaubtem Verb (`Get-Verb`).

---

## 3 Parameter
```powershell
# Maschine: Schul-PC
function Get-FreierSpeicher {
    param(
        [string]$Laufwerk = 'C'          # Standardwert
    )
    $d = Get-PSDrive -Name $Laufwerk
    [math]::Round($d.Free / 1GB, 1)
}

Get-FreierSpeicher                  # nutzt C
Get-FreierSpeicher -Laufwerk D      # benannter Parameter
```

> [!warning] Häufiger Fehler
> Funktionen werden **ohne Klammern und ohne Komma** aufgerufen:
> richtig `Test-Server -Name DC01 -Port 389` · falsch `Test-Server('DC01', 389)`

---

## 4 Parameter prüfen (Validierung)
Der Computer prüft die Zutaten **bevor** er anfängt.

| Attribut | Prüft | Beispiel |
|---|---|---|
| `Mandatory` | muss angegeben werden | `[Parameter(Mandatory)]` |
| `ValidateSet` | nur bestimmte Werte | `[ValidateSet('DC','WEB','DB')]` |
| `ValidateRange` | Zahlenbereich | `[ValidateRange(1,65535)]` |
| `ValidatePattern` | Regex | `[ValidatePattern('^EXA-')]` |
| `ValidateNotNullOrEmpty` | nicht leer | |
| `ValidateScript` | eigene Prüfung | `[ValidateScript({ Test-Path $_ })]` |

```powershell
# Maschine: Hyper-V-Host
function Test-ServerPort {
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^(EXA|CON)-')]
        [string]$ComputerName,

        [ValidateRange(1, 65535)]
        [int]$Port = 3389
    )
    Test-NetConnection -ComputerName $ComputerName -Port $Port -InformationLevel Quiet
}

Test-ServerPort -ComputerName EXA-DC01 -Port 389
Test-ServerPort -ComputerName Google            # Fehler: passt nicht zum Muster
```

---

## 5 Erweiterte Funktion (CmdletBinding)
Mit [[CmdletBinding]] verhält sich die Funktion wie ein echtes Cmdlet: `-Verbose`, `-ErrorAction`, `-WhatIf`, `-Confirm` funktionieren automatisch.

```powershell
# Maschine: Schul-PC
function Remove-AlteLogs {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$Pfad,

        [int]$Tage = 30
    )
    $grenze = (Get-Date).AddDays(-$Tage)
    Write-Verbose "Lösche Dateien älter als $grenze in $Pfad"

    Get-ChildItem $Pfad -File -Filter *.log |
        Where-Object LastWriteTime -lt $grenze |
        ForEach-Object {
            if ($PSCmdlet.ShouldProcess($_.FullName, 'Löschen')) {
                Remove-Item $_.FullName
            }
        }
}

Remove-AlteLogs -Pfad C:\Temp -Tage 7 -WhatIf -Verbose    # nur anzeigen
```

> [!example] Für Kinder erklärt
> `-WhatIf` ist wie **„Was wäre, wenn?“**: Der Roboter sagt dir, was er tun **würde**, macht es aber nicht. Perfekt zum Ausprobieren, bevor etwas gelöscht wird.

---

## 6 Pipeline-Eingabe
```powershell
# Maschine: Hyper-V-Host
function Get-ServerStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$ComputerName
    )
    begin   { Write-Verbose 'Start' }                  # einmal am Anfang
    process {                                          # für jedes Objekt
        foreach ($c in $ComputerName) {
            [pscustomobject]@{
                Server = $c
                Online = Test-Connection $c -Count 1 -Quiet
            }
        }
    }
    end     { Write-Verbose 'Fertig' }                 # einmal am Ende
}

'EXA-DC01', 'EXA-SRV01' | Get-ServerStatus
Get-ServerStatus -ComputerName EXA-DC01, EXA-SRV02
```

---

## 7 Rückgabewerte
- **Alles**, was eine Funktion ausgibt und nicht abgefangen wird, ist Rückgabe.
- `return $wert` beendet die Funktion und gibt `$wert` zurück.
- Ungewollte Ausgaben unterdrücken: `| Out-Null` oder `$null = …`
- `Write-Host` ist **keine** Rückgabe (nur Bildschirm) → für Daten immer Objekte ausgeben.

```powershell
# Maschine: Schul-PC
function Test-Rueckgabe {
    New-Item C:\Temp\x -ItemType Directory -Force | Out-Null   # sonst landet das Ordnerobjekt in der Rückgabe
    return 'fertig'
}
$ergebnis = Test-Rueckgabe    # 'fertig'
```

---

## 8 Hilfe einbauen
[[Kommentarbasierte-Hilfe]] macht `Get-Help` für eigene Funktionen nutzbar.
```powershell
function Get-FreierSpeicher {
<#
.SYNOPSIS
    Zeigt freien Speicher eines Laufwerks in GB.
.DESCRIPTION
    Liest das PSDrive und rundet auf eine Nachkommastelle.
.PARAMETER Laufwerk
    Laufwerksbuchstabe ohne Doppelpunkt. Standard: C.
.EXAMPLE
    Get-FreierSpeicher -Laufwerk D
#>
    param([string]$Laufwerk = 'C')
    [math]::Round((Get-PSDrive $Laufwerk).Free / 1GB, 1)
}
Get-Help Get-FreierSpeicher -Full
```

---

## 9 Splatting
[[Splatting]]: Parameter in einer [[Hashtable]] sammeln und mit `@` übergeben – lange Befehle werden lesbar.
```powershell
# Maschine: EXA-DC01
$param = @{
    Name              = 'Max Mustermann'
    SamAccountName    = 'max.mustermann'
    Path              = 'OU=Benutzer,DC=example,DC=com'
    Enabled           = $true
    AccountPassword   = (Read-Host 'Startpasswort' -AsSecureString)
    ChangePasswordAtLogon = $true
}
New-ADUser @param          # @ statt $ !
```

---

## 10 Kontrollfragen
1. Was bewirkt `[CmdletBinding(SupportsShouldProcess)]`?
2. Warum ist `Test-Server('DC01', 389)` falsch?
3. Schreibe den `param`-Block für einen Pflichtparameter `Rolle`, der nur `DC`, `WEB` oder `DB` erlaubt.

> [!success]- Lösungen
> 1. Die Funktion unterstützt `-WhatIf` und `-Confirm`; Aktionen werden mit `$PSCmdlet.ShouldProcess()` abgesichert.
> 2. PowerShell übergibt das als **ein** Array an den ersten Parameter. Richtig: `Test-Server -Name DC01 -Port 389`.
> 3.
> ```powershell
> param([Parameter(Mandatory)][ValidateSet('DC','WEB','DB')][string]$Rolle)
> ```
