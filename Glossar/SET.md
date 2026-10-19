---
aliases: [Switch Embedded Teaming, SET-Team]
tags: [glossar, glossar/virtualisierung, az-802]
en: "Switch Embedded Teaming"
de: "In den vSwitch integriertes Teaming"
bereich: Virtualisierung
---

# SET

NIC-Teaming direkt im Hyper-V-[[vSwitch]] – bis zu 8 gleiche Karten, kompatibel mit RDMA.

- Empfohlen statt klassischem LBFO-Teaming für Hyper-V
- Teaming **in der VM**: zwei vNICs an verschiedenen externen Switches + `-AllowTeaming On`

Maschine: **Hyper-V-Host**
```powershell
New-VMSwitch -Name SETswitch -NetAdapterName 'NIC1','NIC2' -EnableEmbeddedTeaming $true
```

**Siehe auch:** [[vSwitch]] · [[RDMA]] · [[NIC]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
