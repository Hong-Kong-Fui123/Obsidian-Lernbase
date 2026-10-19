---
aliases: [Conditional Forwarder, Bedingte Weiterleitungen]
tags: [glossar, glossar/netzwerk, az-802]
en: "Conditional Forwarder"
de: "Bedingte Weiterleitung"
bereich: Netzwerk
---

# Bedingte Weiterleitung

DNS-Server leitet Anfragen für **eine bestimmte Domäne** an festgelegte Server weiter.

- Typisch: Partner-Forest (contoso.com), Azure-Private-Zonen über [[Azure DNS Private Resolver]]
- AD-integriert speichern, damit alle DNS-Server sie kennen

Maschine: **EXA-DC01**
```powershell
Add-DnsServerConditionalForwarderZone -Name contoso.com -MasterServers 192.168.2.10 -ReplicationScope Forest
```

**Siehe auch:** [[DNS]] · [[Vertrauensstellungen]]
**Thema:** [[AZ-802 4 Netzwerk DNS DHCP]] · [[AZ-802 Übersicht]]
