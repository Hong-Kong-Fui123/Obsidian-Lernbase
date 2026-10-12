---
aliases:
  - "Cmdlet"
  - "Commandlet"
tags:
  - glossar
  - glossar/scripting
en: "Cmdlet"
de: "PowerShell-Befehl"
bereich: Scripting
---

**Cmdlet** = *Cmdlet*
**Deutsch:** PowerShell-Befehl

## Kurz
Eingebauter PowerShell-Befehl im Schema Verb-Nomen, z. B. `Get-Service`.

> [!example] Für Kinder erklärt
> Ein Satz aus Tun-Wort und Ding: „Hole Dienst“.

## Details
- Liefert .NET-Objekte zurück
- Gemeinsame Parameter: `-Verbose`, `-ErrorAction`, `-WhatIf`
- Eigene Funktionen mit `[CmdletBinding()]` verhalten sich wie Cmdlets

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-Command -CommandType Cmdlet | Measure-Object
Get-Help Get-Service -Examples
```

## Prüfungsfrage
Wie findest du alle Cmdlets, die etwas mit Firewall zu tun haben?

> [!success]- Lösung
> `Get-Command *Firewall*`

## Siehe auch
[[Verb-Nomen]] · [[PowerShell]] · [[CmdletBinding]] · [[01_PS-Grundlagen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
