---
aliases:
  - VM-Import
  - Import-VM
  - Hyper-V Import
tags:
  - glossar
  - glossar/virtualisierung
en: VM Import
de: VM-Import
bereich: Virtualisierung
---

**VM-Import** = *VM Import*
**Deutsch:** VM-Import

## Kurz
Registriert oder kopiert einen Export als VM auf einem Hyper-V-Host.

## Details
- `-Path` zeigt auf die **.vmcx-Datei**, nicht auf den Ordner
- Modi: Register in-place · Restore (`-Copy`) · Copy (`-Copy -GenerateNewId`)
- Vorher mit [[Compare-VM]] prüfen

## Beispiel
Maschine: **Ziel-Hyper-V-Host**
```powershell
$vmcx = (Get-ChildItem 'C:\export1\EXA-SRV02\Virtual Machines\*.vmcx').FullName
Import-VM -Path $vmcx -Copy -GenerateNewId -VirtualMachinePath 'C:\VM2\EXA-SRV02b'
```

## Prüfungsfrage
Was ändert `-GenerateNewId` – und was nicht?

> [!success]- Lösung
> Nur die Hyper-V-VM-ID; Computername, SID und IP im Gast bleiben gleich.

## Siehe auch
[[VM-Export]] · [[Compare-VM]] · [[VMCX]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
