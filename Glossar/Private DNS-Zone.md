---
aliases: [Private DNS Zone, Azure Private DNS, Privates Azure DNS]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure Private DNS zone"
de: "Private DNS-Zone"
bereich: Virtualisierung-Cloud
---

# Private DNS-Zone

DNS-Zone in Azure, die nur in **verknüpften VNets** sichtbar ist.

- VNet-Verknüpfung, optional **Auto-Registrierung** der VMs (A-Einträge)
- Ein VNet: max. **eine** Zone mit Auto-Registrierung; Zone: viele VNets
- Ideal für Private Endpoints und Split-Horizon (gleichnamige öffentliche Zone)
- Kein DNSSEC, keine Zonenübertragung

Maschine: **Admin-PC (Az-Modul)**
```powershell
New-AzPrivateDnsZone -Name az.example.com -ResourceGroupName rg-az802-lab
New-AzPrivateDnsVirtualNetworkLink -ZoneName az.example.com -ResourceGroupName rg-az802-lab -Name link1 -VirtualNetworkId $vnet.Id -EnableRegistration
```

**Siehe auch:** [[Azure DNS]] · [[VNet]] · [[DNS-Richtlinien]]
**Thema:** [[Azure DNS und DHCP hybrid]] · [[AZ-802 4 Netzwerk DNS DHCP]]
