---
aliases:
  - Sysprep
  - System Preparation Tool
tags:
  - glossar
  - glossar/virtualisierung
en: System Preparation Tool
de: Systemvorbereitung
bereich: Virtualisierung
---

**Sysprep** = *System Preparation Tool*
**Deutsch:** Systemvorbereitung

## Kurz
Werkzeug, das eine Windows-Installation generalisiert: neue SID, Hardware-Erkennung und OOBE beim nächsten Start.

## Details
- Pflicht für Golden Images und Klone, die parallel laufen
- Vorher Domäne verlassen
- Anzahl der Durchläufe je Installation begrenzt

## Beispiel
Maschine: **Gast-VM (z. B. EXA-CL01b)**
```powershell
C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown
```

## Prüfungsfrage
Warum muss ein geklonter Server vor dem Domänenbeitritt mit Sysprep behandelt werden?

> [!success]- Lösung
> Sonst gleiche Maschinen-SID wie das Original → Konflikte bei Sicherheit und Verwaltung.

## Siehe auch
[[SID]] · [[VM-Import]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
