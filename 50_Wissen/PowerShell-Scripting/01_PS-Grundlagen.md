---
title: PowerShell – Grundlagen
tags: [powershell, grundlagen]
kapitel: "[[00_PS-Uebersicht]]"
---

# 01 PowerShell – Grundlagen
← [[00_PS-Uebersicht]] · → [[02_PS-Variablen-Datentypen]]

**Inhalt:** [[#1 Was ist PowerShell]] · [[#2 Versionen]] · [[#3 Werkzeuge]] · [[#4 Cmdlets]] · [[#5 Hilfe finden]] · [[#6 Aliase]] · [[#7 Provider und Laufwerke]] · [[#8 Profil]] · [[#9 Kontrollfragen]]

---

## 1 Was ist PowerShell
- [[PowerShell]] ist **Kommandozeile** ([[CLI]]) und **Skriptsprache** in einem.
- Anders als CMD oder Bash arbeitet sie mit **Objekten**, nicht mit Text → [[04_PS-Objekte-Pipeline]].
- Fast alles in Windows Server ist per PowerShell steuerbar: AD, DNS, DHCP, Hyper-V, IIS, Azure.

> [!example] Für Kinder erklärt
> Stell dir vor, du sprichst mit einem Roboter. In der **Konsole** sagst du ihm einen Befehl und er macht ihn sofort. In einem **Skript** schreibst du viele Befehle auf einen Zettel, und der Roboter arbeitet den ganzen Zettel ab – auch wenn du nicht dabei bist.

---

## 2 Versionen

| | Windows PowerShell 5.1 | PowerShell 7 |
|---|---|---|
| Programm | `powershell.exe` | `pwsh.exe` |
| Basis | .NET Framework | .NET (plattformübergreifend) |
| Betriebssystem | nur Windows, vorinstalliert | Windows, Linux, macOS |
| Weiterentwicklung | nur Fehlerbehebung | aktiv |
| Kompatibilität | alle Windows-Module | fast alle |

```powershell
# Maschine: Schul-PC
$PSVersionTable.PSVersion
```

---

## 3 Werkzeuge

| Werkzeug | Einsatz |
|---|---|
| PowerShell-Konsole | einzelne Befehle testen |
| Windows PowerShell ISE | einfacher Editor mit Konsole (nur 5.1, wird nicht weiterentwickelt) |
| **Visual Studio Code** + Erweiterung „PowerShell“ | empfohlen: Farben, Autovervollständigung, Debugger, Git |
| Windows Terminal | moderne Konsole mit Tabs |

Tastenkürzel Konsole:

| Taste | Wirkung |
|---|---|
| `Tab` | Befehl/Parameter/Pfad vervollständigen |
| `Strg + Leertaste` | alle Möglichkeiten anzeigen |
| `↑` / `↓` | letzte Befehle |
| `F7` | Befehlsverlauf (Konsole) |
| `Strg + C` | laufenden Befehl abbrechen |

---

## 4 Cmdlets
Ein [[Cmdlet]] ist ein PowerShell-Befehl im Schema [[Verb-Nomen]].

```text
Get    -  Service    -Name Spooler
Verb      Nomen      Parameter  Wert
```

| Verb | Bedeutung | Beispiel |
|---|---|---|
| `Get` | lesen | `Get-Service` |
| `Set` | ändern | `Set-Service` |
| `New` | anlegen | `New-Item` |
| `Remove` | löschen | `Remove-Item` |
| `Start` / `Stop` | starten / stoppen | `Stop-Service` |
| `Test` | prüfen (Ergebnis True/False) | `Test-Path` |
| `Invoke` | ausführen | `Invoke-Command` |

```powershell
# Maschine: Schul-PC
Get-Verb | Sort-Object Verb | Select-Object -First 10
Get-Command -Verb Get -Noun *Service*
```

> [!example] Für Kinder erklärt
> Cmdlets sind wie Sätze aus **Tun-Wort + Ding**: „Hole Dienst“, „Stoppe Dienst“, „Teste Pfad“. Wenn du das Ding kennst, kannst du fast jedes Tun-Wort davorsetzen und erraten, wie der Befehl heißt.

---

## 5 Hilfe finden
Die drei wichtigsten Befehle – damit findest du **alles** selbst:

| Befehl | Frage |
|---|---|
| `Get-Command` | Welche Befehle gibt es? |
| `Get-Help` | Wie benutze ich den Befehl? |
| `Get-Member` | Was steckt im Ergebnis? |

```powershell
# Maschine: Schul-PC (Admin, einmalig, braucht Internet)
Update-Help -UICulture en-US -ErrorAction SilentlyContinue

# Maschine: Schul-PC
Get-Command *firewall*
Get-Help Get-Service -Examples
Get-Help Get-Service -Parameter Name
Get-Help about_If                   # Themenhilfe zu Sprachelementen
Get-Service | Get-Member            # Eigenschaften und Methoden
```

---

## 6 Aliase
Ein [[PS-Alias]] ist ein Kurzname.

| Alias | Cmdlet |
|---|---|
| `dir`, `ls`, `gci` | `Get-ChildItem` |
| `cd` | `Set-Location` |
| `cls` | `Clear-Host` |
| `?` | `Where-Object` |
| `%` | `ForEach-Object` |
| `select` | `Select-Object` |

```powershell
# Maschine: Schul-PC
Get-Alias dir
Get-Alias -Definition Get-ChildItem
```
> [!warning] In Skripten keine Aliase
> In der Konsole sparen sie Zeit, in Skripten machen sie den Code unlesbar → [[13_PS-Stil-Best-Practices]].

---

## 7 Provider und Laufwerke
Über [[PS-Provider]] sieht vieles wie ein Laufwerk aus:

```powershell
# Maschine: Schul-PC
Get-PSDrive
Set-Location HKLM:\SOFTWARE\Microsoft      # Registry wie Ordner
Get-ChildItem Env:                          # Umgebungsvariablen
Get-ChildItem Cert:\LocalMachine\My         # Zertifikate (Bezug PKI!)
Set-Location C:\
```

---

## 8 Profil
Ein [[PS-Profil]] ist ein Skript, das bei jedem Start der Konsole läuft (eigene Funktionen, Aliase, Prompt).

```powershell
# Maschine: Schul-PC
$PROFILE                                    # Pfad anzeigen
if (-not (Test-Path $PROFILE)) { New-Item $PROFILE -ItemType File -Force }
notepad $PROFILE
```
Beispielinhalt:
```powershell
Set-Location 'C:\Users\ITA7-TN10\Downloads\Netzwerktechnik'
function vault { Set-Location 'C:\Users\ITA7-TN10\Downloads\Netzwerktechnik' }
```

---

## 9 Kontrollfragen
1. Wie heißt das Programm von PowerShell 7?
2. Du suchst einen Befehl, der DNS-Einträge anzeigt. Wie findest du ihn?
3. Warum gehören Aliase nicht in Skripte?

> [!success]- Lösungen
> 1. `pwsh.exe`
> 2. `Get-Command *DnsServerResourceRecord*` oder `Get-Command -Module DnsServer`, dann `Get-Help`.
> 3. Schwer lesbar für andere, und Aliase wie `ls`, `curl` sind nicht auf allen Systemen gleich.
