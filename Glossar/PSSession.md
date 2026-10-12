---
aliases:
  - "PSSession"
  - "Session"
  - "PowerShell-Sitzung"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Session"
de: "PowerShell-Sitzung"
bereich: Scripting
---

**PSSession** = *PowerShell Session*
**Deutsch:** PowerShell-Sitzung

## Kurz
Dauerhafte Remoting-Verbindung zu einem Computer, die für mehrere Befehle offen bleibt.

> [!example] Für Kinder erklärt
> Ein Telefonat, bei dem man nicht nach jedem Satz auflegt.

## Details
- `New-PSSession`, `Invoke-Command -Session`, `Remove-PSSession`
- Variablen bleiben zwischen Befehlen erhalten
- Dateien kopieren: `Copy-Item -ToSession`

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
$s = New-PSSession EXA-DC01
Invoke-Command -Session $s { Get-ADDomain }
Remove-PSSession $s
```

## Prüfungsfrage
Warum Sitzungen am Ende mit `Remove-PSSession` schließen?

> [!success]- Lösung
> Sie belegen sonst Ressourcen und Verbindungen auf dem Zielserver.

## Siehe auch
[[PS-Remoting]] · [[WinRM]] · [[11_PS-Remoting]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
