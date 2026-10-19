---
aliases: [PS Direct, PowerShell-Direct]
tags: [glossar, glossar/virtualisierung, az-802]
en: "PowerShell Direct"
de: "PowerShell direkt in die VM"
bereich: Virtualisierung
---

# PowerShell Direct

PowerShell vom Hyper-V-Host in eine VM über den **VMBus** – ohne Netzwerk, Firewall oder Remoting-Konfiguration.

- Nur auf dem Host, auf dem die VM läuft; Anmeldedaten **des Gastes**
- Gegenstück für Linux: SSH Direct (`hvc ssh`)

Maschine: **Hyper-V-Host**
```powershell
Enter-PSSession -VMName EXA-WEB01 -Credential EXAMPLE\Administrator
Invoke-Command -VMName EXA-WEB01 -ScriptBlock { hostname }
```

**Siehe auch:** [[PS-Remoting]] · [[Hyper-V]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
