---
aliases: [DNS Security Extensions, DNS-Sicherheitserweiterungen]
tags: [glossar, glossar/sicherheit-pki, az-802]
en: "DNS Security Extensions"
de: "DNS-Sicherheitserweiterungen"
bereich: Sicherheit-PKI
---

# DNSSEC

Signiert DNS-Zonen, damit Resolver gefälschte Antworten erkennen.

- Einträge: RRSIG, DNSKEY, DS, NSEC/NSEC3
- Schlüssel: KSK (signiert DNSKEY) und ZSK (signiert Einträge); Schlüsselmaster
- Windows-Clients validieren nur per NRPT (GPO)

Maschine: **EXA-DC01**
```powershell
Invoke-DnsServerZoneSign -ZoneName example.com -SignWithDefault -Force
```

**Siehe auch:** [[DNS]] · [[PKI und Zertifikatdienste]]
**Thema:** [[AZ-802 4 Netzwerk DNS DHCP]] · [[AZ-802 Übersicht]]
