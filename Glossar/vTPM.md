---
aliases:
  - vTPM
  - virtuelles TPM
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Trusted Platform Module
de: Virtuelles TPM
bereich: Virtualisierung
---

**vTPM** = *Virtual Trusted Platform Module*
**Deutsch:** Virtuelles TPM

## Kurz
Virtuelles Sicherheitsmodul für Generation-2-VMs, z. B. für [[BitLocker]] und Windows 11.

## Details
- Schlüssel geschützt durch Guardian-Zertifikate des Hosts
- Bei Umzug Zertifikate mitnehmen
- Aktivieren: `Enable-VMTPM` (VM aus, Key Protector nötig)

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Set-VMKeyProtector -VMName EXA-CL02 -NewLocalKeyProtector
Enable-VMTPM -VMName EXA-CL02
```

## Prüfungsfrage
Warum braucht eine Windows-11-VM ein vTPM?

> [!success]- Lösung
> Windows 11 setzt TPM 2.0 als Systemanforderung voraus.

## Siehe auch
[[VMGS]] · [[BitLocker]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
