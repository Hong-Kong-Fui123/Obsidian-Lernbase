---
title: PowerShell – Fehlerbehandlung und Debugging
tags: [powershell, fehler, try-catch, debugging, logging]
kapitel: "[[00_PS-Uebersicht]]"
---

# 08 PowerShell – Fehlerbehandlung und Debugging
← [[07_PS-Funktionen-Parameter]] · → [[09_PS-Dateien-Daten]]

**Inhalt:** [[#1 Idee]] · [[#2 Fehlerarten]] · [[#3 ErrorAction]] · [[#4 try, catch, finally]] · [[#5 Eigene Fehler mit throw]] · [[#6 Ausgabe-Kanäle]] · [[#7 Protokollieren]] · [[#8 Debugging]] · [[#9 Kontrollfragen]]

---

## 1 Idee

> [!example] Für Kinder erklärt
> Beim Seiltanzen gibt es ein **Sicherheitsnetz**. `try` heißt: „**Versuch** mal, über das Seil zu laufen.“ Fällst du runter, fängt dich das Netz – das ist `catch`. Und `finally` ist: „Egal ob geschafft oder gefallen – **danach** verbeugst du dich.“

Ohne Fehlerbehandlung bricht ein Skript mitten drin ab oder läuft blind weiter – beides ist im Betrieb gefährlich (halb angelegte Benutzer, halb gelöschte Dateien).

---

## 2 Fehlerarten

| Art | Verhalten | Beispiel |
|---|---|---|
| **Nicht abbrechend** (non-terminating) | Meldung, Skript läuft weiter | `Get-Item C:\gibtsnicht` |
| **Abbrechend** (terminating) | Skript/Block stoppt | Syntaxfehler, `throw`, `-ErrorAction Stop` |

> [!important] Wichtig
> `try/catch` fängt **nur abbrechende** Fehler. Die meisten Cmdlet-Fehler sind nicht abbrechend → immer `-ErrorAction Stop` ergänzen.

---

## 3 ErrorAction

| Wert | Wirkung |
|---|---|
| `Continue` | Standard: Fehler anzeigen, weiter |
| `SilentlyContinue` | Fehler verschweigen, weiter |
| `Stop` | in abbrechenden Fehler umwandeln → `catch` greift |
| `Inquire` | nachfragen |

```powershell
# Maschine: Schul-PC
Get-Item C:\gibtsnicht -ErrorAction SilentlyContinue
$ErrorActionPreference = 'Stop'     # für das ganze Skript (oben ins Skript)
```

---

## 4 try, catch, finally
```powershell
# Maschine: EXA-DC01
try {
    $user = Get-ADUser -Identity 'max.mustermann' -ErrorAction Stop
    Disable-ADAccount -Identity $user -ErrorAction Stop
    Write-Host "Konto $($user.SamAccountName) deaktiviert."
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Warning 'Benutzer existiert nicht.'
}
catch {
    Write-Error "Unerwarteter Fehler: $($_.Exception.Message)"
}
finally {
    Write-Verbose 'Vorgang beendet.'      # läuft immer
}
```

| Teil | Inhalt |
|---|---|
| `try` | riskanter Code |
| `catch [Typ]` | nur bestimmte Fehlerart (optional, spezielle zuerst) |
| `catch` | alle anderen Fehler; `$_` = Fehlerobjekt |
| `finally` | Aufräumen: Verbindungen schließen, Log beenden |

Fehlertyp herausfinden:
```powershell
# Maschine: EXA-DC01
Get-ADUser gibtsnicht
$Error[0].Exception.GetType().FullName
```

---

## 5 Eigene Fehler mit throw
```powershell
# Maschine: Schul-PC
function Get-Konfig {
    param([string]$Pfad)
    if (-not (Test-Path $Pfad)) {
        throw "Konfigurationsdatei fehlt: $Pfad"
    }
    Get-Content $Pfad -Raw | ConvertFrom-Json
}
```

---

## 6 Ausgabe-Kanäle

| Cmdlet | Kanal | Sichtbar | Einsatz |
|---|---|---|---|
| (Objekt ausgeben) | Output | ja, weiterverarbeitbar | **Daten** |
| `Write-Host` | Host | nur Bildschirm | farbige Hinweise für Menschen |
| `Write-Verbose` | Verbose | nur mit `-Verbose` | Details zum Ablauf |
| `Write-Warning` | Warning | gelb | Hinweis, kein Abbruch |
| `Write-Error` | Error | rot | Fehler melden |
| `Write-Debug` | Debug | nur mit `-Debug` | Entwickler-Infos |
| `Write-Information` | Information | mit `-InformationAction Continue` | strukturierte Infos |

---

## 7 Protokollieren
```powershell
# Maschine: EXA-DC01 – komplette Sitzung mitschreiben
Start-Transcript -Path "C:\Skripte\log\lauf_$(Get-Date -Format yyyyMMdd_HHmm).txt"
# … Skript …
Stop-Transcript
```

Eigene Log-Funktion (wiederverwendbar):
```powershell
function Write-Log {
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('INFO','WARN','FEHLER')][string]$Stufe = 'INFO',
        [string]$Datei = "$PSScriptRoot\skript.log"
    )
    $zeile = '{0:yyyy-MM-dd HH:mm:ss} [{1}] {2}' -f (Get-Date), $Stufe, $Text
    Add-Content -Path $Datei -Value $zeile -Encoding UTF8
    if ($Stufe -eq 'FEHLER') { Write-Warning $Text }
}
Write-Log 'Skript gestartet'
Write-Log 'Benutzer fehlt' -Stufe WARN
```

Ereignisanzeige als Ziel (Admin, einmalig Quelle anlegen):
```powershell
# Maschine: EXA-SRV01
New-EventLog -LogName Application -Source 'LabSkripte'
Write-EventLog -LogName Application -Source 'LabSkripte' -EventId 1000 -EntryType Information -Message 'Backup ok'
```

---

## 8 Debugging
[[Debugging]] = Fehler im eigenen Code finden.

> [!example] Für Kinder erklärt
> Wenn das Rezept schiefgeht, gehst du **Schritt für Schritt** durch und probierst nach jedem Schritt: Ist der Teig noch richtig? So findest du die Stelle, an der es falsch wurde. Ein **Haltepunkt** ist ein Zettel „Hier anhalten und nachschauen!“.

| Methode | Wie |
|---|---|
| Zwischenausgaben | `Write-Verbose "Wert: $x"` + Aufruf mit `-Verbose` |
| Haltepunkt VS Code | Klick links neben die Zeilennummer (roter Punkt) → `F5` |
| Haltepunkt Konsole | `Set-PSBreakpoint -Script .\x.ps1 -Line 12` |
| Variable beobachten | `Set-PSBreakpoint -Variable zaehler -Mode Write` |
| Strenger Modus | `Set-StrictMode -Version Latest` → Tippfehler in Variablennamen fallen auf |

Steuerung im Debugger (VS Code):

| Taste | Wirkung |
|---|---|
| `F5` | starten / weiter bis zum nächsten Haltepunkt |
| `F10` | nächste Zeile (Funktionen überspringen) |
| `F11` | in Funktion hineinspringen |
| `Umschalt + F5` | beenden |

---

## 9 Kontrollfragen
1. Warum greift `catch` bei `Get-Item C:\gibtsnicht` ohne Zusatz nicht?
2. Wofür ist `finally`?
3. Warum gehören Daten nicht in `Write-Host`?

> [!success]- Lösungen
> 1. Nicht abbrechender Fehler; erst `-ErrorAction Stop` macht ihn abbrechend.
> 2. Code, der immer läuft (Aufräumen), egal ob Fehler oder nicht.
> 3. `Write-Host` gibt nur auf den Bildschirm aus; die Daten können nicht weiterverarbeitet, gespeichert oder exportiert werden.
