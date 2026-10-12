---
title: PowerShell – Skripte, Module, Sicherheit
tags: [powershell, skript, modul, execution-policy, aufgabenplanung]
kapitel: "[[00_PS-Uebersicht]]"
---

# 10 PowerShell – Skripte, Module, Sicherheit
← [[09_PS-Dateien-Daten]] · → [[11_PS-Remoting]]

**Inhalt:** [[#1 Vom Befehl zum Skript]] · [[#2 Skript-Vorlage]] · [[#3 Skripte starten]] · [[#4 Ausführungsrichtlinie]] · [[#5 Skripte signieren]] · [[#6 Zugangsdaten sicher speichern]] · [[#7 Module]] · [[#8 Automatisch ausführen (Aufgabenplanung)]] · [[#9 Kontrollfragen]]

---

## 1 Vom Befehl zum Skript

> [!example] Für Kinder erklärt
> In der Konsole sagst du dem Roboter jeden Befehl **einzeln**. Ein [[PS-Skript]] ist ein **Zettel mit allen Befehlen**, den du speicherst. Morgen gibst du dem Roboter einfach wieder den Zettel – er macht alles genau gleich, ohne dass du dich erinnern musst.

| Schritt | Was |
|---|---|
| 1 | Befehle in der Konsole einzeln testen |
| 2 | In VS Code als `.ps1` speichern (UTF-8 mit BOM) |
| 3 | Feste Werte durch **Parameter** ersetzen |
| 4 | Fehlerbehandlung + Log ergänzen |
| 5 | Mit `-WhatIf` testen, dann echt ausführen |
| 6 | In Git versionieren |

---

## 2 Skript-Vorlage
`C:\Skripte\Vorlage.ps1`
```powershell
<#
.SYNOPSIS
    Kurzbeschreibung in einem Satz.
.DESCRIPTION
    Was das Skript tut, Voraussetzungen, Maschine.
.PARAMETER Pfad
    Beschreibung des Parameters.
.EXAMPLE
    .\Vorlage.ps1 -Pfad C:\Temp -WhatIf
.NOTES
    Autor: SveBeh · Version 1.0 · 2026-10-12
#>
#Requires -Version 5.1
#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ })]
    [string]$Pfad
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$log = Join-Path $PSScriptRoot ("log_{0:yyyyMMdd_HHmm}.txt" -f (Get-Date))
Start-Transcript -Path $log | Out-Null

try {
    # --- Funktionen ---
    function Get-Beispiel { param([string]$P) Get-ChildItem $P }

    # --- Hauptteil ---
    Write-Verbose "Starte mit $Pfad"
    $ergebnis = Get-Beispiel -P $Pfad
    $ergebnis | Select-Object Name, Length
}
catch {
    Write-Error "Abbruch: $($_.Exception.Message)"
    exit 1
}
finally {
    Stop-Transcript | Out-Null
}
```

| Element | Zweck |
|---|---|
| `<# … #>` | [[Kommentarbasierte-Hilfe]] → `Get-Help .\Vorlage.ps1` |
| `#Requires` | Mindestversion, Admin-Rechte, Module erzwingen |
| `param()` | Skript-Parameter (wie bei Funktionen) |
| `Set-StrictMode` | Tippfehler in Variablen werden Fehler |
| `exit 1` | Rückgabecode für Aufgabenplanung/Pipelines (0 = ok) |

---

## 3 Skripte starten

| Aufruf | Wo |
|---|---|
| `.\skript.ps1` | im Ordner des Skripts (`.\` ist Pflicht!) |
| `C:\Skripte\skript.ps1 -Pfad C:\Temp` | mit vollem Pfad |
| `& 'C:\Mein Ordner\skript.ps1'` | Pfad mit Leerzeichen |
| `. .\funktionen.ps1` | **Dot-Sourcing**: Funktionen in die aktuelle Sitzung laden |
| `powershell.exe -ExecutionPolicy Bypass -File C:\Skripte\skript.ps1` | von außen (CMD, Aufgabenplanung) |

> [!example] Für Kinder erklärt
> `.\` bedeutet „**hier**, in diesem Ordner“. PowerShell startet aus Sicherheitsgründen nichts, nur weil es so heißt wie eine Datei – du musst zeigen, **wo** sie liegt.

---

## 4 Ausführungsrichtlinie
Die [[Execution-Policy]] legt fest, welche Skripte laufen dürfen.

| Richtlinie | Bedeutung |
|---|---|
| `Restricted` | keine Skripte (Standard Windows-Client) |
| `AllSigned` | nur signierte Skripte |
| `RemoteSigned` | lokale ja, heruntergeladene nur signiert (Standard Windows Server) |
| `Unrestricted` | alle, mit Warnung bei Downloads |
| `Bypass` | alles, keine Warnung (für Automatisierung) |

```powershell
# Maschine: Schul-PC
Get-ExecutionPolicy -List
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Unblock-File .\skript.ps1               # Download-Markierung entfernen
```
> [!warning] Kein Sicherheitsfeature
> Die Richtlinie schützt vor **versehentlichem** Ausführen, nicht vor Angreifern (`-ExecutionPolicy Bypass` umgeht sie). Im Unternehmen per **GPO** setzen → Bezug Modul 3.

---

## 5 Skripte signieren
Bezug zu Modul 2 (PKI): Code-Signing-Zertifikat der CA auf EXA-SRV01.
```powershell
# Maschine: EXA-CL01 (Zertifikat "Code Signing" von der Enterprise CA vorhanden)
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Select-Object -First 1
Set-AuthenticodeSignature -FilePath C:\Skripte\Vorlage.ps1 -Certificate $cert -TimestampServer http://timestamp.digicert.com
Get-AuthenticodeSignature C:\Skripte\Vorlage.ps1          # Status: Valid
```
Zeitstempel braucht Internet; im Lab ohne Internet `-TimestampServer` weglassen. Danach ist `AllSigned` per GPO möglich. Jede Änderung am Skript macht die Signatur ungültig.

---

## 6 Zugangsdaten sicher speichern
Niemals Passwörter im Klartext ins Skript schreiben.

| Methode | Einsatz |
|---|---|
| `Get-Credential` | interaktiv abfragen |
| `Export-Clixml` | verschlüsselt speichern (nur **derselbe Benutzer auf demselben Rechner** kann entschlüsseln, DPAPI) |
| gMSA | Dienstkonto ohne Passwortpflege für Aufgabenplanung |
| SecretManagement-Modul / Azure Key Vault | zentrale Tresore |

```powershell
# Maschine: Hyper-V-Host
Get-Credential EXAMPLE\Administrator | Export-Clixml C:\Skripte\cred_admin.xml
$cred = Import-Clixml C:\Skripte\cred_admin.xml
Invoke-Command -ComputerName EXA-DC01 -Credential $cred -ScriptBlock { hostname }
```

---

## 7 Module
Ein [[PS-Modul]] bündelt Funktionen zum Wiederverwenden.

```powershell
# Maschine: Schul-PC
Get-Module -ListAvailable | Select-Object Name, Version -First 15
Import-Module ActiveDirectory
Get-Command -Module ActiveDirectory | Measure-Object
Find-Module PSScriptAnalyzer                 # PowerShell Gallery (Internet)
Install-Module PSScriptAnalyzer -Scope CurrentUser
```

Eigenes Modul bauen:
```text
C:\Users\ITA7-TN10\Documents\WindowsPowerShell\Modules\
└── LabTools\
    ├── LabTools.psm1      ← Funktionen
    └── LabTools.psd1      ← Manifest (Version, Autor, Exporte)
```
```powershell
# Maschine: Schul-PC
$ziel = "$HOME\Documents\WindowsPowerShell\Modules\LabTools"
New-Item $ziel -ItemType Directory -Force | Out-Null
@'
function Get-FreierSpeicher {
    param([string]$Laufwerk = 'C')
    [math]::Round((Get-PSDrive $Laufwerk).Free / 1GB, 1)
}
Export-ModuleMember -Function Get-FreierSpeicher
'@ | Set-Content "$ziel\LabTools.psm1" -Encoding UTF8
New-ModuleManifest -Path "$ziel\LabTools.psd1" -RootModule LabTools.psm1 -ModuleVersion 1.0.0 -Author SveBeh
Import-Module LabTools -Force
Get-FreierSpeicher
```
Ordnerpfade für Module: `$env:PSModulePath -split ';'`

---

## 8 Automatisch ausführen (Aufgabenplanung)
```powershell
# Maschine: EXA-SRV01 (Admin)
$aktion  = New-ScheduledTaskAction -Execute 'powershell.exe' `
           -Argument '-NoProfile -ExecutionPolicy Bypass -File C:\Skripte\Systembericht.ps1'
$ausloeser = New-ScheduledTaskTrigger -Daily -At '06:30'
$konto   = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName 'Lab-Systembericht' -Action $aktion -Trigger $ausloeser -Principal $konto

Start-ScheduledTask -TaskName 'Lab-Systembericht'
Get-ScheduledTaskInfo -TaskName 'Lab-Systembericht' | Select-Object LastRunTime, LastTaskResult   # 0 = ok
```
GUI: `taskschd.msc` → Aufgabenplanungsbibliothek.

---

## 9 Kontrollfragen
1. Warum startet `skript.ps1` nicht, `.\skript.ps1` aber schon?
2. Schützt `RemoteSigned` vor einem Angreifer? Begründe.
3. Was passiert mit der Signatur, wenn du ein Komma im Skript änderst?

> [!success]- Lösungen
> 1. PowerShell sucht Befehle nicht im aktuellen Ordner (Schutz vor untergeschobenen Dateien); `.\` gibt den Ort ausdrücklich an.
> 2. Nein, sie ist leicht zu umgehen (`Bypass`, Inhalt kopieren). Sie verhindert nur versehentliches Ausführen.
> 3. Ungültig (Hash passt nicht mehr) → neu signieren.
