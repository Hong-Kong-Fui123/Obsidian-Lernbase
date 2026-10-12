---
aliases:
  - "Kommentar"
  - "Comment"
tags:
  - glossar
  - glossar/scripting
en: "Comment"
de: "Kommentar (Erläuterung im Code)"
bereich: Scripting
---

**Kommentar** = *Comment*
**Deutsch:** Kommentar (Erläuterung im Code)

## Kurz
Text im Code, den PowerShell ignoriert. Erklärt anderen Menschen den Code.

> [!example] Für Kinder erklärt
> Ein Notizzettel am Rand, den nur Menschen lesen, nicht der Roboter.

## Details
- Einzeilig: `# Text`
- Mehrzeilig: `<# … #>`
- Gute Kommentare erklären **warum**, nicht **was**

## Beispiel
Maschine: **Schul-PC**
```powershell
# Altkonten 30 Tage behalten (Datenschutz-Vorgabe)
$tage = 30
```

## Prüfungsfrage
Welcher Kommentar ist besser: `# Schleife` oder `# nur Server im Lab, CON-Forest separat`?

> [!success]- Lösung
> Der zweite – er erklärt den Grund.

## Siehe auch
[[Kommentarbasierte-Hilfe]] · [[13_PS-Stil-Best-Practices]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
