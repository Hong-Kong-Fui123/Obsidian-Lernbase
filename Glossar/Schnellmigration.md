---
aliases:
  - Schnellmigration
  - Quick Migration
  - Quick-Migration
tags:
  - glossar
  - glossar/virtualisierung
en: Quick Migration
de: Schnellmigration
bereich: Virtualisierung
---

**Schnellmigration** = *Quick Migration*
**Deutsch:** Schnellmigration

## Kurz
Vorläufer der Livemigration im Cluster: VM wird **gespeichert** (Zustand auf gemeinsamen Speicher), Besitz wechselt, VM wird auf dem Zielknoten fortgesetzt.

## Details
- Spürbare Pause (Sekunden), Clients können Verbindungen verlieren
- Geht auch mit **angehaltenen** VMs; Livemigration nur mit laufenden
- Nur nutzen, wenn Livemigration nicht möglich ist

## Beispiel
Maschine: **Clusterknoten**
```powershell
Move-ClusterVirtualMachineRole -Name EXA-WEB01 -Node EXA-HV02 -MigrationType Quick
```

## Prüfungsfrage
Wann greift man noch zur Schnellmigration?

> [!success]- Lösung
> Wenn Livemigration nicht möglich ist, z. B. bei angehaltener VM oder Problemen mit dem Migrationsnetz.

## Siehe auch
[[Livemigration]] · [[Failover-Cluster]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
