---
aliases:
  - "PS-Pipeline"
  - "Pipeline (PowerShell)"
  - "Pipe"
tags:
  - glossar
  - glossar/scripting
en: "PowerShell Pipeline"
de: "PowerShell-Pipeline"
bereich: Scripting
---

**PS-Pipeline** = *PowerShell Pipeline*
**Deutsch:** PowerShell-Pipeline

## Kurz
Weitergabe von Objekten von einem Befehl zum nächsten mit `|`.

> [!example] Für Kinder erklärt
> Ein Fließband: jeder Arbeiter macht eine Sache und gibt weiter.

## Details
- Aktuelles Objekt: `$_` bzw. `$PSItem`
- Typische Kette: holen → filtern → sortieren → auswählen → ausgeben
- Nicht zu verwechseln mit der CI/CD-Pipeline → [[CI-CD]]

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-Process | Where-Object CPU -gt 10 | Sort-Object CPU -Descending | Select-Object -First 5
```

## Prüfungsfrage
Was steht in `$_`?

> [!success]- Lösung
> Das Objekt, das gerade durch die Pipeline läuft.

## Siehe auch
[[Objekt]] · [[Scriptblock]] · [[04_PS-Objekte-Pipeline]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
