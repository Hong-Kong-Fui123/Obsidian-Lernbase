---
aliases:
  - "Execution-Policy"
  - "Ausführungsrichtlinie"
  - "ExecutionPolicy"
tags:
  - glossar
  - glossar/scripting
en: "Execution Policy"
de: "Ausführungsrichtlinie"
bereich: Scripting
---

**Execution-Policy** = *Execution Policy*
**Deutsch:** Ausführungsrichtlinie

## Kurz
Einstellung, welche Skripte PowerShell ausführen darf.

> [!example] Für Kinder erklärt
> Ein Schild an der Tür: „Nur mit Ausweis rein“ – hält Unachtsame auf, aber keine Einbrecher.

## Details
- `Restricted`, `AllSigned`, `RemoteSigned`, `Unrestricted`, `Bypass`
- Bereiche: `MachinePolicy`, `CurrentUser`, `Process` …
- Kein Sicherheitsfeature gegen Angreifer; zentral per GPO setzen

## Beispiel
Maschine: **Schul-PC**
```powershell
Get-ExecutionPolicy -List
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Prüfungsfrage
Was erlaubt `RemoteSigned`?

> [!success]- Lösung
> Lokale Skripte ohne Signatur, heruntergeladene nur mit gültiger Signatur.

## Siehe auch
[[PS-Skript]] · [[GPO]] · [[10_PS-Skripte-Module-Sicherheit]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
