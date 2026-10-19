---
aliases:
  - "PS-Remoting"
  - "Remoting"
  - "PowerShell Remoting"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Remoting"
de: "PowerShell-Fernsteuerung"
bereich: Scripting
---

**PS-Remoting** = *PowerShell Remoting*
**Deutsch:** PowerShell-Fernsteuerung

## Kurz
Ausführen von PowerShell-Befehlen auf entfernten Computern über WinRM (oder SSH in PS 7).

> [!example] Für Kinder erklärt
> Eine Fernbedienung – für einen oder für alle Fernseher gleichzeitig.

## Details
- Interaktiv: `Enter-PSSession`
- Viele Server parallel: `Invoke-Command`
- Lokale Variablen: `$using:`

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Invoke-Command -ComputerName EXA-DC01, EXA-SRV01 -ScriptBlock { hostname }
```

## Prüfungsfrage
Unterschied `Enter-PSSession` und `Invoke-Command`?

> [!success]- Lösung
> Interaktiv auf einem Server vs. Befehl auf vielen Servern mit Rückgabe.

## Siehe auch
[[WinRM]] · [[PSSession]] · [[Scriptblock]] · [[11_PS-Remoting]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]

**AZ-802:** [[AZ-802 2 Hybride Verwaltung]] · [[AZ-802 Übersicht]]
