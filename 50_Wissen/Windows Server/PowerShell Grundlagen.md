---
typ: wissen
thema: Windows Server
tags: [windows-server, powershell]
aliases: [PowerShell Einführung]
quelle: Schulfolien „Einführung in PowerShell“ + Übung 1
status: lernen
---
# PowerShell Grundlagen

Thema: [[Windows Server]] · Befehlssammlungen: [[PowerShell AD und GPO]] · [[Netzwerk und DNS Befehle]]

## Kernpunkte
- Shell + Skriptsprache, **objektorientiert** (.NET) → Pipeline übergibt **Objekte**, nicht Text
- Cmdlets = **Verb-Substantiv** (`Get-Service`, `New-ADUser`)
- Alte Befehle (`dir`, `cd`) = **Aliase**; externe Tools (`ipconfig`, `netsh`) laufen weiter
- Erweiterung über **Module** (`Import-Module`), PSSnapins veraltet

## Die wichtigsten Werkzeuge
**Maschine: beliebig** (z. B. EXA-SRV01)
```powershell
Get-Help Get-Service -Examples      # Hilfe, Beispiele
Get-Command -Noun *DNS*             # Befehle finden
Get-Service | Get-Member            # Eigenschaften/Methoden eines Objekts
Get-Service -DisplayName "Windows Update" | Format-List *
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table Name, Id, CPU
Get-PSDrive                         # Laufwerke inkl. HKLM:, Cert:, Env:
Stop-Service Spooler -WhatIf        # nur anzeigen, was passieren würde
```

| Ausgabe | Zweck |
|---|---|
| `Format-Table` / `ft` | Tabelle (Standard) |
| `Format-List` / `fl` | alle Eigenschaften als Liste |
| `Out-File`, `Export-Csv`, `ConvertTo-Html` | Datei/Export |
| `Out-GridView` | Fenster mit Filter |

**Common Parameters:** `-WhatIf` (Probelauf) · `-Confirm` (nachfragen) · `-Verbose`
**Profile:** `$Profile` → Skript, das bei jedem Start lädt (Aliase, Module). Nicht in Remotesitzungen.

> [!question] Selbsttest
> Was ist der Unterschied zwischen `Get-Service | Format-List *` und `Get-Service | Get-Member`?

## 📄 Unterlagen
- Folien: [[PowerShell_Einfuehrung.pdf#page=2|Einleitung]] · [[PowerShell_Einfuehrung.pdf#page=4|Cmdlets, Get-Help]] · [[PowerShell_Einfuehrung.pdf#page=5|Get-Command]] · [[PowerShell_Einfuehrung.pdf#page=6|PSDrives]] · [[PowerShell_Einfuehrung.pdf#page=7|Aliase]] · [[PowerShell_Einfuehrung.pdf#page=8|Module]] · [[PowerShell_Einfuehrung.pdf#page=10|Ausgabe]] · [[PowerShell_Einfuehrung.pdf#page=11|Piping]] · [[PowerShell_Einfuehrung.pdf#page=13|Common Parameters]] · [[PowerShell_Einfuehrung.pdf#page=14|Profile]]
- Übung: [[Uebung_PowerShell_1.pdf|Übung 1 (20 Aufgaben)]] · [[Uebung_PowerShell_1_Loesung.pdf|Lösung]]
