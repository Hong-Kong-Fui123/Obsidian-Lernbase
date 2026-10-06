---
typ: glossar
begriff: DNS-Record
synonyme: [Resource Record, RR, DNS-Eintrag]
thema: "[[DNS]]"
tags: [glossar, dns, netzwerk, windows-server]
erstellt: 2026-10-06
---

# DNS-Record

**Definition:** Eintrag in einer DNS-Zone, der einem Namen eine Information zuordnet (z. B. Name → IP).

## Record-Typen

| Typ | Zweck | Beispiel |
|---|---|---|
| A | Name → IPv4 | `www → 192.168.1.10` |
| AAAA | Name → IPv6 | `www → 2001:db8::10` |
| CNAME | Alias → anderer Name | `ftp → www.example.com` |
| MX | Mailserver der Domain (Priorität) | `10 mail.example.com` |
| NS | Zuständiger DNS-Server der Zone | `ns1.example.com` |
| PTR | IP → Name (Reverse Lookup) | `10.1.168.192.in-addr.arpa → www` |
| SOA | Zonen-Stammdaten (Primary NS, Serial, TTL) | 1× pro Zone |
| SRV | Dienst-Ort (Host + Port), wichtig für AD | `_ldap._tcp.example.com` |
| TXT | Freitext (SPF, Verifizierung) | `v=spf1 mx -all` |

## Befehle

**Abfragen** – Client (Windows, PowerShell):
```powershell
Resolve-DnsName www.example.com -Type A
nslookup -type=MX example.com
```

**Anlegen** – Windows Server mit DNS-Rolle (PowerShell):
```powershell
Add-DnsServerResourceRecordA -ZoneName "example.com" -Name "www" -IPv4Address "192.168.1.10"
```

## Merke
- A/AAAA = Vorwärts, PTR = Rückwärts
- AD findet DCs über SRV-Records → ohne DNS kein AD
- CNAME darf nicht auf Zonen-Apex (`example.com`) liegen

## Verwandt
[[DNS]] · [[Forward-Lookup-Zone]] · [[Reverse-Lookup-Zone]] · [[Active Directory]] · [[TTL]]