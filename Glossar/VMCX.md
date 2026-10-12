---
aliases:
  - VMCX
  - vmcx
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Machine Configuration (binary)
de: VM-Konfigurationsdatei
bereich: Virtualisierung
---

**VMCX** = *Virtual Machine Configuration (binary)*
**Deutsch:** VM-Konfigurationsdatei

## Kurz
Binäre Konfigurationsdatei einer Hyper-V-VM (seit Server 2016, ersetzt das XML-Format).

## Details
- Liegt im Ordner `Virtual Machines`, Dateiname = VM-GUID
- Ziel von `Import-VM -Path` und `Compare-VM -Path`
- Binär → nicht von Hand bearbeiten

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-ChildItem 'C:\export1\EXA-SRV02\Virtual Machines\*.vmcx'
```

## Prüfungsfrage
Warum scheitert `Import-VM -Path C:\export1\EXA-SRV02`?

> [!success]- Lösung
> `-Path` erwartet die .vmcx-Datei, nicht den Ordner.

## Siehe auch
[[VMRS]] · [[VMGS]] · [[VM-Import]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
