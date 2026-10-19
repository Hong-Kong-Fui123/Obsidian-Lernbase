---
aliases: [Private Resolver, DNS Private Resolver]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Azure DNS Private Resolver"
de: "Privater DNS-Resolver in Azure"
bereich: Virtualisierung-Cloud
---

# Azure DNS Private Resolver

Verwalteter Azure-Dienst für hybride Namensauflösung ohne eigene DNS-VMs.

- **Eingehender Endpunkt:** lokale DNS-Server leiten (bedingt) dorthin weiter → private Azure-Namen
- **Ausgehender Endpunkt + Weiterleitungsregelsatz:** Azure fragt lokale DNS-Server (z. B. example.com)
- Alternative: DNS-Server-VM in Azure mit Weiterleitung an 168.63.129.16

**Siehe auch:** [[Bedingte Weiterleitung]] · [[VNet]] · [[DNS]]
**Thema:** [[AZ-802 4 Netzwerk DNS DHCP]] · [[AZ-802 Übersicht]]
