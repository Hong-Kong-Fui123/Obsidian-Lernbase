---
aliases:
  - "Eigenschaft"
  - "Property"
  - "Attribut"
tags:
  - glossar
  - glossar/scripting
en: "Property"
de: "Eigenschaft"
bereich: Scripting
---

**Eigenschaft** = *Property*
**Deutsch:** Eigenschaft

## Kurz
Wert, der zu einem Objekt gehört, z. B. `Status` eines Dienstes.

> [!example] Für Kinder erklärt
> Die Angaben auf der Sammelkarte: Name, Farbe, Stärke.

## Details
- Zugriff mit Punkt: `$svc.Status`
- Anzeigen: `Get-Member -MemberType Property`
- Berechnete Eigenschaft in `Select-Object`

## Beispiel
Maschine: **Schul-PC**
```powershell
(Get-Service Spooler).Status
```

## Prüfungsfrage
Wie liest du den Namen des Computers aus `Get-CimInstance Win32_ComputerSystem`?

> [!success]- Lösung
> `(Get-CimInstance Win32_ComputerSystem).Name`

## Siehe auch
[[Objekt]] · [[Methode]] · [[04_PS-Objekte-Pipeline]] · [[00_PS-Uebersicht]] · [[00_Glossar-Index]]
