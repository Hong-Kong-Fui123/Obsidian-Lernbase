---
aliases:
  - Konfigurationsversion
  - VM-Version
  - VM Configuration Version
tags:
  - glossar
  - glossar/virtualisierung
en: VM Configuration Version
de: VM-Konfigurationsversion
bereich: Virtualisierung
---

**Konfigurationsversion** = *VM Configuration Version*
**Deutsch:** VM-Konfigurationsversion

## Kurz
Version des VM-Formats. Der Zielhost muss sie unterstützen, sonst ist kein Import möglich.

## Details
- Server 2025 nutzt eine höhere Version als Server 2022
- Prüfen: `Get-VMHostSupportedVersion`
- Anheben mit `Update-VMVersion` – danach kein Import auf ältere Hosts
- Gilt auch für [[Livemigration]]: nur auf Hosts mit gleicher oder neuerer Version; ab 10.0 dynamische [[Prozessorkompatibilität]] (Server 2025)

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-VM | Select Name, Version
Get-VMHostSupportedVersion | Select Version, IsDefault
```

## Prüfungsfrage
Warum Vorsicht bei `Update-VMVersion`?

> [!success]- Lösung
> Nicht umkehrbar; die VM läuft danach nicht mehr auf älteren Hosts.

## Siehe auch
[[VM-Import]] · [[Compare-VM]] · [[HyperV-VM-Export-Import]] · [[Livemigration]] · [[00_Glossar-Index]]
