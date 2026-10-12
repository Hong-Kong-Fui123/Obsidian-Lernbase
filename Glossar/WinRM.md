---
aliases:
  - "WinRM"
  - "Windows Remote Management"
  - "WS-Management"
tags:
  - glossar
  - glossar/scripting
en: "Windows Remote Management"
de: "Windows-Fernverwaltung"
bereich: Scripting
---

**WinRM** = *Windows Remote Management*
**Deutsch:** Windows-Fernverwaltung

## Kurz
Windows-Dienst und Protokoll (WS-Management), über das PowerShell-Remoting läuft.

> [!example] Für Kinder erklärt
> Die unsichtbare Leitung, über die die Fernbedienung mit dem Fernseher spricht.

## Details
- Ports 5985 (HTTP) und 5986 (HTTPS)
- Aktivieren: `Enable-PSRemoting` oder GPO
- In der Domäne Authentifizierung per Kerberos

## Beispiel
Maschine: **EXA-SRV01**
```powershell
Get-Service WinRM
Test-WSMan EXA-DC01
```

## Prüfungsfrage
Welche Ports nutzt WinRM?

> [!success]- Lösung
> 5985 (HTTP) und 5986 (HTTPS).

## Siehe auch
[[PS-Remoting]] · [[PSSession]] · [[11_PS-Remoting]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
