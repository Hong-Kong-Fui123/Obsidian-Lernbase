---
typ: wissen
thema: AZ-802
tags: [az-802, jea, sicherheit, protokollierung]
aliases: [JEA Sicherheit, JEA Auditing, JEA Transkript]
erstellt: 2026-10-29
status: lernen
---
# JEA 6 – Sicherheit und Überwachung

Übersicht: [[JEA Übersicht]] · Zurück: [[JEA Bereitstellen und Verbinden]] · Weiter: [[JEA Lab DNS-Operator]] · Sicherheit allgemein: [[AZ-802 6 Sicherheit]]

## Gefährliche Freigaben (Ausbruch zum Admin)
| Nicht freigeben | Warum |
|---|---|
| `Invoke-Expression`, `Invoke-Command`, `Start-Process`, `New-Service`, `Register-ScheduledTask` | führen **beliebigen Code** als RunAs-Konto aus |
| `Add-LocalGroupMember`, `Add-ADGroupMember`, `Set-Acl` | Benutzer macht sich selbst zum Admin |
| `Copy-Item`, `Set-Content` + FileSystem-Provider | eigenes Skript an Autostart-Orte schreiben |
| `cmd.exe`, `powershell.exe` als VisibleExternalCommands | volle Shell |
| Cmdlets mit `-ScriptBlock`/`-FilePath`-Parametern ohne Einschränkung | Code-Ausführung über Parameter |
| Platzhalter wie `'*-Service'` | erlaubt auch `New-Service`, `Set-Service` |
**Regel:** so wenig wie möglich, Parameter + Werte einschränken (`ValidateSet`/`ValidatePattern`), lieber eigene geprüfte **Funktionen**.

## Weitere Schutzmaßnahmen
- `RunAsVirtualAccountGroups` statt vollem Admin (Pflicht auf DCs).
- `RequiredGroups` für zusätzliche Bedingung (z. B. Smartcard-Gruppe).
- Rollenfunktions- und `.pssc`-Dateien vor Änderung schützen (NTFS: nur Admins schreiben).
- Standard-Endpunkt `Microsoft.PowerShell` für Helpdesk **nicht** freigeben – sonst umgehen sie JEA.
- Regelmäßig prüfen: `Get-PSSessionCapability` je Gruppe.

## Überwachung
| Quelle | Was steht drin |
|---|---|
| **Transkript** (`TranscriptDirectory`) | jede Sitzung: verbundener Benutzer, RunAs-Konto, alle Befehle + Ausgaben |
| Ereignisprotokoll *Microsoft-Windows-PowerShell/Operational* | Modul- und Skriptblockprotokollierung (Ereignis **4104**) |
| *Microsoft-Windows-WinRM/Operational* | Verbindungen zum Endpunkt |
| Zentral | Ereignisweiterleitung oder [[Azure Monitor]] ([[DCR]]) → Auswertung mit [[KQL]] |
```powershell
# Maschine: EXA-SRV01
Get-ChildItem C:\JEA\Transkripte | Sort-Object LastWriteTime -Descending | Select-Object -First 5
Get-WinEvent -LogName 'Microsoft-Windows-PowerShell/Operational' -MaxEvents 20 |
  Where-Object Id -eq 4104 | Format-List TimeCreated, Message
```
> [!tip] Skriptblockprotokollierung per GPO
> Computerkonfiguration → Administrative Vorlagen → Windows-Komponenten → Windows PowerShell → **PowerShell-Skriptblockprotokollierung aktivieren** (+ Transkription).

## Prüfungsfrage
Ein JEA-Benutzer darf `Start-Process` ausführen. Welches Risiko besteht?

> [!success]- Lösung
> Er kann beliebige Programme (z. B. `powershell.exe`) **als RunAs-Konto** starten – also mit Admin-Rechten. Damit ist JEA ausgehebelt.

## Quellen
- [JEA Security considerations – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/security-considerations?view=powershell-7.4)
- [Auditing and reporting on JEA – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/audit-and-report)
