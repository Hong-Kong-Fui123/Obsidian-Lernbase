---
aliases: [Network Security Group, Netzwerksicherheitsgruppe]
tags: [glossar, glossar/virtualisierung-cloud, az-802]
en: "Network Security Group"
de: "Netzwerksicherheitsgruppe"
bereich: Virtualisierung-Cloud
---

# NSG

Zustandsbehaftete Firewall-Regeln in Azure für ein Subnetz oder eine Netzwerkkarte.

- Regeln mit Priorität 100–4096 – kleinere Zahl wird zuerst geprüft
- Standardregeln: VNet-intern erlaubt, eingehend aus dem Internet verweigert
- Prüfen: Network Watcher → effektive Sicherheitsregeln / IP-Flussüberprüfung

**Siehe auch:** [[VNet]] · [[JIT-VM-Zugriff]] · [[Azure Bastion]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
