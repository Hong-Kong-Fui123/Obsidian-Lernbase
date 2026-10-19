---
aliases: [DNS Policies, DNS-Richtlinie]
tags: [glossar, glossar/netzwerk, az-802]
en: "DNS Policies"
de: "DNS-Richtlinien"
bereich: Netzwerk
---

# DNS-Richtlinien

Steuern DNS-Antworten nach Client-Subnetz, Uhrzeit, Schnittstelle oder Abfrage – z. B. Split-Brain, Geo-Steuerung, Sperren.

- Bausteine: Client-Subnetz, Zonenbereich (Zone Scope), Abfrageauflösungsrichtlinie
- Aktionen: ALLOW, DENY, IGNORE

Maschine: **EXA-DC01**
```powershell
Add-DnsServerQueryResolutionPolicy -Name BlockMalware -Action IGNORE -FQDN 'EQ,*.boese.example'
```

**Siehe auch:** [[DNS]] · [[DNSSEC]]
**Thema:** [[AZ-802 4 Netzwerk DNS DHCP]] · [[AZ-802 Übersicht]]
