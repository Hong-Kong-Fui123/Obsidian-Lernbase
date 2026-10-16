---
aliases:
  - Livemigration
  - Live-Migration
  - Live Migration
  - LM
tags:
  - glossar
  - glossar/virtualisierung
en: Live Migration
de: Livemigration
bereich: Virtualisierung
---

**Livemigration** = *Live Migration*
**Deutsch:** Livemigration

## Kurz
Verschiebt eine **laufende** VM ohne spürbare Unterbrechung auf einen anderen Hyper-V-Host. Übertragen werden Arbeitsspeicher und Zustand.

## Details
- RAM wird in mehreren Runden kopiert, geänderte Seiten erneut; am Ende Pause im ms-Bereich
- Ohne Cluster seit Server 2012; im Cluster liegen die VHDX auf [[CSV]] oder SMB
- Voraussetzungen: gleicher CPU-Hersteller, gleicher [[vSwitch]]-Name, passende [[Konfigurationsversion]], Authentifizierung [[Kerberos]] oder [[CredSSP]]
- Ersetzt **keine** Hochverfügbarkeit: bei Absturz hilft nur Failover

## Beispiel
Maschine: **EXA-HV01 (Quellhost)**
```powershell
Enable-VMMigration
Move-VM -Name EXA-WEB01 -DestinationHost EXA-HV02
```

## Prüfungsfrage
Was wird bei einer Livemigration im Cluster übertragen – und was nicht?

> [!success]- Lösung
> Übertragen: RAM und Zustand. Nicht: die VHDX – sie liegen auf gemeinsamem Speicher und wechseln nur den Besitzer.

## Siehe auch
[[Shared-Nothing-Livemigration]] · [[Speichermigration]] · [[Schnellmigration]] · [[Failover-Cluster]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
