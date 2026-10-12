---
tags: [glossar, hyper-v]
aliases: [Kompatibilitätsbericht]
---
# Compare-VM

**Kurz:** Cmdlet, das vor dem Import einen Kompatibilitätsbericht erstellt.

- `$r = Compare-VM -Path <vmcx> -Copy` → `$r.Incompatibilities`
- Probleme beheben, dann `Import-VM -CompatibilityReport $r` (Zielhost)

**Siehe auch:** [[VM-Import]] · [[vSwitch]] · [[Konfigurationsversion]] · [[HyperV-VM-Export-Import]]
