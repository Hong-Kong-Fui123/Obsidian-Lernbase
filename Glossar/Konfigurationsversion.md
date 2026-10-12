---
tags: [glossar, hyper-v]
aliases: [VM-Version, VM Configuration Version]
---
# Konfigurationsversion

**Kurz:** Version des VM-Formats. Der Zielhost muss sie unterstützen.

- Prüfen: `Get-VMHostSupportedVersion` (Zielhost)
- Anheben: `Update-VMVersion` – danach kein Import auf älteren Hosts mehr

**Siehe auch:** [[VM-Import]] · [[Compare-VM]] · [[HyperV-VM-Export-Import]]
