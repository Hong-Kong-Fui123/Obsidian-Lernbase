---
tags: [glossar, hyper-v]
aliases: [Import-VM, Hyper-V Import]
---
# VM-Import

**Kurz:** Registriert oder kopiert einen Export als VM auf einem Hyper-V-Host.

- Cmdlet: `Import-VM -Path <datei.vmcx>` (Hyper-V-Host)
- `-Path` zeigt auf die `.vmcx`-Datei, nicht auf den Ordner
- Modi: Register in-place · Restore (`-Copy`) · Copy (`-Copy -GenerateNewId`)

**Siehe auch:** [[VM-Export]] · [[Compare-VM]] · [[VMCX]] · [[HyperV-VM-Export-Import]]
