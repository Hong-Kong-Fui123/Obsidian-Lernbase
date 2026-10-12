---
title: PowerShell – Objekte und Pipeline
tags: [powershell, objekte, pipeline]
kapitel: "[[00_PS-Uebersicht]]"
---

# 04 PowerShell – Objekte und Pipeline
← [[03_PS-Operatoren]] · → [[05_PS-Bedingungen]]

**Inhalt:** [[#1 Objekte]] · [[#2 Pipeline]] · [[#3 Filtern Where-Object]] · [[#4 Auswählen Select-Object]] · [[#5 Sortieren, Gruppieren, Zählen]] · [[#6 ForEach-Object]] · [[#7 Ausgabe formatieren und exportieren]] · [[#8 Eigene Objekte]] · [[#9 Kontrollfragen]]

---

## 1 Objekte

> [!example] Für Kinder erklärt
> Ein [[Objekt]] ist wie eine **Sammelkarte**. Auf der Karte stehen **Eigenschaften**: Name, Farbe, Stärke. Und auf der Rückseite steht, was die Figur **kann** (Methoden): springen, rennen. Ein Dienst in Windows ist auch so eine Karte: Name = Spooler, Status = Running, und er **kann** Start() und Stop().

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| [[Eigenschaft]] (Property) | Wert des Objekts | `$svc.Status` |
| [[Methode]] (Method) | Aktion des Objekts | `$svc.Stop()` |
| Typ | Art des Objekts | `System.ServiceProcess.ServiceController` |

```powershell
# Maschine: Schul-PC
$svc = Get-Service -Name Spooler
$svc.Status                        # Eigenschaft lesen
$svc | Get-Member                  # alle Eigenschaften und Methoden
$svc | Get-Member -MemberType Property
$svc | Format-List *               # alle Werte anzeigen
```

**Text vs. Objekt:** CMD liefert Text (`ipconfig`) – den musst du zerschneiden. PowerShell liefert Objekte (`Get-NetIPAddress`) – du greifst direkt auf `.IPAddress` zu.

---

## 2 Pipeline
Die [[PS-Pipeline]] `|` gibt die Objekte eines Befehls an den nächsten weiter.

> [!example] Für Kinder erklärt
> Die Pipeline ist wie ein **Fließband in einer Fabrik**. Der erste Arbeiter legt alle Spielzeuge aufs Band. Der zweite nimmt nur die roten heraus. Der dritte sortiert sie nach Größe. Der vierte packt sie in eine Kiste. Jeder macht **eine** Sache und gibt weiter.

```mermaid
flowchart LR
  A[Get-Service<br/>alle Dienste] -->|Objekte| B[Where-Object<br/>nur gestoppte] -->|Objekte| C[Sort-Object<br/>nach Name] -->|Objekte| D[Export-Csv<br/>in Datei]
```

```powershell
# Maschine: Schul-PC
Get-Service |
    Where-Object Status -eq 'Stopped' |
    Sort-Object DisplayName |
    Select-Object Name, DisplayName, StartType |
    Export-Csv C:\Temp\dienste_gestoppt.csv -NoTypeInformation -Encoding UTF8 -Delimiter ';'
```
Zeilenumbruch nach `|` ist erlaubt → gut lesbar.

---

## 3 Filtern Where-Object

```powershell
# Maschine: Schul-PC
# Kurzform (eine Bedingung)
Get-Process | Where-Object CPU -gt 100

# Langform mit Skriptblock (mehrere Bedingungen)
Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.StartType -eq 'Automatic' }
```
`$_` = das Objekt, das gerade auf dem Fließband liegt.

> [!tip] Links filtern
> Wenn ein Cmdlet selbst filtern kann, ist das schneller: `Get-ADUser -Filter "Department -eq 'IT'"` statt `Get-ADUser -Filter * | Where-Object Department -eq 'IT'`. Bei 10 000 Benutzern ein großer Unterschied.

---

## 4 Auswählen Select-Object

```powershell
# Maschine: Schul-PC
Get-Process | Select-Object Name, Id, WS -First 5
Get-Process | Select-Object -ExpandProperty Name     # nur die Werte, keine Spalte

# Berechnete Eigenschaft: RAM in MB
Get-Process | Select-Object Name,
    @{ Name = 'RAM_MB'; Expression = { [math]::Round($_.WS / 1MB, 1) } } |
    Sort-Object RAM_MB -Descending | Select-Object -First 5
```

---

## 5 Sortieren, Gruppieren, Zählen

| Cmdlet | Zweck | Beispiel |
|---|---|---|
| `Sort-Object` | sortieren | `Sort-Object Name -Descending` |
| `Group-Object` | gruppieren | `Get-Service \| Group-Object Status` |
| `Measure-Object` | zählen, Summe, Durchschnitt | `Get-ChildItem C:\Temp \| Measure-Object Length -Sum` |
| `Select-Object -Unique` | doppelte entfernen | |
| `Compare-Object` | zwei Listen vergleichen | Soll/Ist-Abgleich |

```powershell
# Maschine: Schul-PC
Get-Service | Group-Object Status | Select-Object Name, Count
(Get-ChildItem C:\Windows\Logs -Recurse -File | Measure-Object Length -Sum).Sum / 1MB
```

---

## 6 ForEach-Object
Macht etwas mit **jedem** Objekt auf dem Band.
```powershell
# Maschine: Schul-PC
'EXA-DC01','EXA-SRV01' | ForEach-Object { "Prüfe $_" }
Get-ChildItem C:\Temp\*.log | ForEach-Object { Rename-Item $_.FullName ($_.BaseName + '.old') }
```
Mehr zu Schleifen → [[06_PS-Schleifen]].

---

## 7 Ausgabe formatieren und exportieren

| Ziel | Cmdlet |
|---|---|
| Tabelle am Bildschirm | `Format-Table -AutoSize` |
| Liste am Bildschirm | `Format-List` |
| Fenster mit Filter | `Out-GridView` (nur mit GUI) |
| Textdatei | `Out-File C:\Temp\x.txt` |
| CSV (Excel) | `Export-Csv -NoTypeInformation -Delimiter ';' -Encoding UTF8` |
| JSON | `ConvertTo-Json` |
| HTML-Bericht | `ConvertTo-Html` |

> [!warning] Format-* immer zuletzt
> `Format-Table` erzeugt nur noch Anzeige-Daten. Danach kann man nicht mehr sortieren oder exportieren. Regel: **Filtern links, Formatieren rechts.**

---

## 8 Eigene Objekte
```powershell
# Maschine: Hyper-V-Host
Get-VM | ForEach-Object {
    [pscustomobject]@{
        VM       = $_.Name
        Status   = $_.State
        RAM_GB   = [math]::Round($_.MemoryAssigned / 1GB, 1)
        Uptime_h = [math]::Round($_.Uptime.TotalHours, 1)
    }
} | Format-Table -AutoSize
```

---

## 9 Kontrollfragen
1. Was steht in `$_`?
2. Warum `Where-Object` vor `Format-Table` und nicht danach?
3. Wie zeigst du nur die Namen aller laufenden Dienste als reine Textliste?

> [!success]- Lösungen
> 1. Das aktuelle Objekt in der Pipeline.
> 2. `Format-Table` erzeugt Formatierungsobjekte; danach kann nicht mehr sinnvoll gefiltert werden.
> 3. `Get-Service | Where-Object Status -eq 'Running' | Select-Object -ExpandProperty Name`
