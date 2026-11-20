---
aliases: [DNS DHCP AZ-802]
tags: [az-802, az-802/netzwerk, thema]
bereich: 04
gewicht: 10–15 %
status: offen
---
# 04 Lokale + hybride Netzwerkinfrastruktur (10–15 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 04 Netzwerk - Aufgaben]]

## Prüfungsziele
- [ ] DNS in AD DS integrieren
- [ ] Zonen + Einträge
- [ ] Weiterleitung + bedingte Weiterleitung
- [ ] Hybride Namensauflösung (Azure)
- [ ] DNS-Richtlinien
- [ ] DNSSEC
- [ ] DHCP-Rolle, Bereiche, Reservierungen
- [ ] DHCP-Hochverfügbarkeit
- [ ] IP-Troubleshooting hybrid

## Kernwissen DNS

### Zonentypen
| Typ | Speicher | Merkpunkt |
|---|---|---|
| Primär | Datei oder AD | beschreibbar |
| Sekundär | Datei | Kopie per Zonenübertragung (AXFR/IXFR) |
| Stub | Datei/AD | nur SOA, NS, Glue-A |
| AD-integriert | AD-Partition | Multi-Master, **sichere dynamische Updates** |
| Reverse | `x.x.x.in-addr.arpa` | PTR |

Replikationsbereich AD-integriert: alle DNS-Server im Forest (ForestDnsZones) / Domäne (DomainDnsZones) / Domäne (Kompatibilität) / benutzerdef. Partition.

### Einträge
A, AAAA, CNAME, MX, NS, SOA, PTR, **SRV** (`_ldap._tcp.dc._msdcs`), TXT. Alterung/Aufräumen (Scavenging): No-Refresh + Refresh je 7 Tage Standard.

### Weiterleitung
| Art | Wirkung |
|---|---|
| Weiterleitung | alle unbekannten Anfragen an Server X |
| Bedingte Weiterleitung | nur Domäne Y an Server X (z. B. contoso.com → CON-DC) |
| Stammhinweise | Fallback ohne Weiterleitung |
- Bedingte Weiterleitung kann im AD gespeichert/repliziert werden.

### Hybrid (Azure)
- Azure-DNS-Resolver-IP **168.63.129.16**.
- **Azure DNS Private Resolver**: eingehender Endpunkt (on-prem → Azure privat), ausgehender Endpunkt + Weiterleitungsregelsatz (Azure → on-prem).
- Private DNS-Zonen + VNet-Link (Autoregistrierung).
- VNet-DNS-Server auf eigene DCs in Azure setzen.

### DNS-Richtlinien
- Server-Ebene: `Add-DnsServerQueryResolutionPolicy`. Bausteine: Clientsubnetz, Zonenbereich (Zone Scope), Zeit.
- Einsatz: Geo-Location, Split-Brain, Blockieren, Lastverteilung, Zeit-basierte Antworten.

### DNSSEC
- Signatur der Zone: **KSK** (signiert DNSKEY), **ZSK** (signiert Zone). Einträge RRSIG, DNSKEY, DS, NSEC/NSEC3.
- **Trust Anchor** auf Resolvern; Clients prüfen per **NRPT** (GPO).
- `Invoke-DnsServerZoneSign`. Key Master verwaltet Schlüssel.

## Kernwissen DHCP
- DORA: Discover, Offer, Request, Acknowledge (UDP 67/68). Relay-Agent / `ip helper-address` über Router.
- AD-Autorisierung nötig (`Add-DhcpServerInDC`).
- Bereich, Ausschlüsse, Reservierungen (MAC), Optionen (003 Router, 006 DNS, 015 Domäne), Superbereich, Multicast, Richtlinien.
- **Hochverfügbarkeit (DHCP-Failover)**, max. 2 Server:

| Modus | Prinzip |
|---|---|
| Lastenausgleich | 50/50 (anpassbar) aktiv-aktiv |
| Hot Standby | aktiv-passiv, Reserve-% (Standard 5 %) für Standby |
- **MCLT** (Maximum Client Lead Time), Shared Secret. Alternativ Split-Scope 80/20.
- Azure-VNets: kein eigener DHCP-Server unterstützt → Azure vergibt IPs, statisch nur im Portal (NIC).

### IP-Troubleshooting
`ipconfig /all`, APIPA **169.254.x.x** = kein DHCP, `Test-NetConnection -Port`, `Resolve-DnsName`, Überschneidung on-prem/VNet-Adressraum prüfen, DHCP-Auditlog `C:\Windows\System32\dhcp`.

## Prüfungsfallen
- Sekundärzone kann **nicht** AD-integriert sein.
- Bedingte Weiterleitung ≠ Stub (Stub aktualisiert NS selbst).
- DHCP-Failover nur IPv4, max. 2 Partner.
- In Azure keine Gast-DHCP-Server.

## Leitfragen
1. Wie muss DNS konfiguriert sein, damit EXA-DC01 `con-dc.contoso.com` auflöst?
2. Warum Hot Standby statt Lastenausgleich für eine Außenstelle?
3. Was löst KSK-Rollover aus, wenn kein DS-Eintrag aktualisiert wird?

## Glossar
[[Bedingte Weiterleitung]] · [[DNSSEC]] · [[DHCP-Failover]] · [[Azure DNS Private Resolver]] · [[NRPT]]
