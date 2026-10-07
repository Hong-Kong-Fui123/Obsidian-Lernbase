---
typ: glossar
begriff: DNS-Record
synonyme: [Resource Record, RR, DNS-Eintrag]
thema: "[[DNS]]"
tags: [glossar, dns, netzwerk, windows-server]
erstellt: 2026-10-06
aliases: [DNS-Record, Resource Record, DNS-Eintrag]
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
[[DNS]] · [[DNS vs mDNS]] · [[Forward-Lookup-Zone]] · [[Reverse-Lookup-Zone]] · [[AD DS Überblick|Active Directory]] · [[TTL]]

## 📄 Unterlagen
- Folien: [[DNS_WindowsServer2025.pdf#page=5|Ressourceneinträge]] · [[DNS_Einfuehrung_Folien.pdf#page=5|DNS-Roundrobin]] · [[AD-DS_Ueberblick_Folien.pdf#page=13|SRV-Records: DC finden]]
- Übung: [[DNS_Uebung_1.pdf#page=2|Übung 3: A, CNAME, MX anlegen]] · [[DNS_Uebung_1_Loesung.pdf#page=1|Lösung]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=59|Ressourceneinträge]] · [[70-741_Server2016_Netzwerk.pdf#page=62|Alterung/Aufräumen]]
- Prüfungsfragen: [[Netzwerk_30_Pruefungsfragen.pdf#page=3|F14–27 DNS]]
