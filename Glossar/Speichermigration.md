---
aliases:
  - Speichermigration
  - Storage Migration
  - Storage Live Migration
  - Move-VMStorage
tags:
  - glossar
  - glossar/virtualisierung
en: Storage Migration
de: Speichermigration
bereich: Virtualisierung
---

**Speichermigration** = *Storage Migration*
**Deutsch:** Speichermigration

## Kurz
Verschiebt die **Dateien** einer laufenden VM (VHDX, Konfiguration, Checkpoints, Smart Paging) auf einen anderen Speicherort – die VM bleibt auf **demselben** Host.

## Details
- Keine Unterbrechung; während des Kopierens werden Schreibzugriffe gespiegelt
- Typisch: Volume voll, neues SAN/Volume, Wechsel auf [[CSV]]
- Standard: 2 gleichzeitige Speichermigrationen (`-MaximumStorageMigrations`)

## Beispiel
Maschine: **EXA-HV01**
```powershell
Move-VMStorage -VMName EXA-WEB01 -DestinationStoragePath E:\Hyper-V\EXA-WEB01
```

## Prüfungsfrage
Livemigration oder Speichermigration: Was nutzt man, wenn nur das Volume voll ist?

> [!success]- Lösung
> Speichermigration – der Host bleibt gleich, nur die Dateien ziehen um.

## Siehe auch
[[Livemigration]] · [[Shared-Nothing-Livemigration]] · [[VHDX]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
