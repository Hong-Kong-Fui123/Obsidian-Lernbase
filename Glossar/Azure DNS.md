---
aliases: [Azure-DNS, 168.63.129.16, Öffentliche DNS-Zone Azure]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure DNS"
de: "Azure DNS"
bereich: Virtualisierung-Cloud
---

# Azure DNS

DNS-Dienst von Azure: hostet **öffentliche** Zonen autoritativ (weltweit, Anycast) und **private** Zonen für VNets; dazu die automatische Namensauflösung unter **168.63.129.16**.

- Öffentliche Zone: Delegierung beim Registrar auf die Azure-Nameserver, RBAC, DNSSEC-Signierung
- Kein Ersatz für AD-integriertes DNS (keine Zonenübertragung, keine sicheren dynamischen Updates)
- Eigener DNS-Server in Azure leitet an 168.63.129.16 weiter

Maschine: **Admin-PC (Az-Modul)**
```powershell
New-AzDnsZone -Name contoso.com -ResourceGroupName rg-az802-lab
```

**Siehe auch:** [[Private DNS-Zone]] · [[Azure DNS Private Resolver]] · [[DNS]]
**Thema:** [[Azure DNS und DHCP hybrid]] · [[AZ-802 4 Netzwerk DNS DHCP]]
