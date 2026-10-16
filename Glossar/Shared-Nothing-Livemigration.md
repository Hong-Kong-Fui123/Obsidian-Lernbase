---
aliases:
  - Shared-Nothing-Livemigration
  - Shared Nothing
  - Shared-Nothing
tags:
  - glossar
  - glossar/virtualisierung
en: Shared Nothing Live Migration
de: Livemigration ohne gemeinsamen Speicher
bereich: Virtualisierung
---

**Shared-Nothing-Livemigration** = *Shared Nothing Live Migration*
**Deutsch:** Livemigration ohne gemeinsamen Speicher

## Kurz
Livemigration **inklusive aller VM-Dateien** zwischen zwei Hosts, die keinen gemeinsamen Speicher haben – nur eine Netzwerkverbindung.

## Details
- Seit Server 2012, kein Cluster nötig
- Dauert länger, weil die VHDX mitkopiert werden
- Bei Kerberos Delegierung für **cifs** und **Microsoft Virtual System Migration Service** nötig

## Beispiel
Maschine: **EXA-HV01 (Quellhost)**
```powershell
Move-VM -Name EXA-WEB01 -DestinationHost EXA-HV02 -IncludeStorage -DestinationStoragePath D:\Hyper-V\EXA-WEB01
```

## Prüfungsfrage
Welcher Move-VM-Parameter macht aus einer Livemigration eine Shared-Nothing-Livemigration?

> [!success]- Lösung
> `-IncludeStorage` (mit `-DestinationStoragePath`).

## Siehe auch
[[Livemigration]] · [[Speichermigration]] · [[Eingeschränkte Delegierung]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
