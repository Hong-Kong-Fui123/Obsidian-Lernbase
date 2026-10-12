---
aliases:
  - "PS-Provider"
  - "Provider"
  - "PSDrive"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Provider"
de: "PowerShell-Anbieter (Laufwerke)"
bereich: Scripting
---

**PS-Provider** = *PowerShell Provider*
**Deutsch:** PowerShell-Anbieter (Laufwerke)

## Kurz
Schnittstelle, die Datenquellen wie ein Laufwerk zugänglich macht: Dateisystem, Registry, Zertifikate, Umgebung.

> [!example] Für Kinder erklärt
> Verschiedene Schränke, die alle gleich aufgehen: Schublade auf, reinschauen.

## Details
- `Get-PSDrive` zeigt Laufwerke: `C:`, `HKLM:`, `Cert:`, `Env:`
- Gleiche Befehle überall: `Get-ChildItem`, `Set-Location`
- AD-Modul bringt `AD:` mit

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-ChildItem Cert:\LocalMachine\Root | Select-Object -First 3 Subject
```

## Prüfungsfrage
Wie listest du die Umgebungsvariablen auf?

> [!success]- Lösung
> `Get-ChildItem Env:`

## Siehe auch
[[PowerShell]] · [[01_PS-Grundlagen]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
