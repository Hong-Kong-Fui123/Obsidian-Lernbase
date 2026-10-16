---
aliases:
  - Prozessorkompatibilität
  - Processor Compatibility Mode
  - Prozessorkompatibilitätsmodus
  - CompatibilityForMigrationEnabled
tags:
  - glossar
  - glossar/virtualisierung
en: Processor Compatibility Mode
de: Prozessorkompatibilitätsmodus
bereich: Virtualisierung
---

**Prozessorkompatibilität** = *Processor Compatibility Mode*
**Deutsch:** Prozessorkompatibilitätsmodus

## Kurz
Blendet neuere CPU-Befehle vor der VM aus, damit sie live auf Hosts mit **anderer CPU-Generation desselben Herstellers** ziehen kann.

## Details
- Intel ↔ AMD geht **nie**
- Pro VM, Einstellung nur bei ausgeschalteter VM ändern; kostet ggf. Leistung (Verschlüsselung, Komprimierung)
- Server 2025: **dynamischer** Modus (ab Konfigurationsversion 10.0) nutzt den gemeinsamen Funktionsumfang aller Clusterknoten

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Set-VMProcessor -VMName EXA-WEB01 -CompatibilityForMigrationEnabled $true
```

## Prüfungsfrage
Hilft der Kompatibilitätsmodus bei einem Umzug von Intel auf AMD?

> [!success]- Lösung
> Nein – nur zwischen Generationen desselben Herstellers.

## Siehe auch
[[Livemigration]] · [[Konfigurationsversion]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
