---
aliases:
  - "Try-Catch"
  - "try"
  - "catch"
  - "finally"
  - "Fehlerbehandlung"
tags:
  - glossar
  - glossar/scripting
en: "Try/Catch/Finally"
de: "Fehlerbehandlung"
bereich: Scripting
---

**Try-Catch** = *Try/Catch/Finally*
**Deutsch:** Fehlerbehandlung

## Kurz
Konstrukt zum Abfangen von Fehlern: riskanter Code in `try`, Reaktion in `catch`, Aufräumen in `finally`.

> [!example] Für Kinder erklärt
> Das Sicherheitsnetz beim Seiltanzen.

## Details
- Fängt nur abbrechende Fehler → `-ErrorAction Stop`
- Fehlerobjekt im `catch`: `$_`
- `finally` läuft immer

## Beispiel
Maschine: **Schul-PC**
```powershell
try { Get-Item C:\gibtsnicht -ErrorAction Stop }
catch { "Fehler: $($_.Exception.Message)" }
```

## Prüfungsfrage
Warum braucht man oft `-ErrorAction Stop` im `try`?

> [!success]- Lösung
> Die meisten Cmdlet-Fehler sind nicht abbrechend und würden sonst nicht abgefangen.

## Siehe auch
[[Debugging]] · [[08_PS-Fehlerbehandlung-Debugging]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
