---
typ: wissen
thema: AZ-802
tags: [az-802, dns, dhcp, hybrid, netzwerk, exam]
aliases: [AZ-802 Bereich 4, AZ-802 Netzwerk, Hybride Namensauflösung]
gewicht: "10–15 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 4 – Netzwerk lokal und hybrid (10–15 %)

Kapitel: [[AZ-802 Übersicht]] · Zurück: [[AZ-802 3 Virtuelle Maschinen]] · Weiter: [[AZ-802 5 Speicher und Dateidienste]]
Vorwissen: [[AD und DNS Grundlagen]] · [[Forward-Lookup-Zone]] · [[Reverse-Lookup-Zone]] · [[DNS-Records]] · [[DHCP-Server]] · [[Netzwerk und DNS Befehle]]

## Prüfungsziele (Checkliste)
- [ ] DNS mit AD DS integrieren
- [ ] Zonen und Einträge erstellen → [[Forward-Lookup-Zone]] · [[DNS-Records]]
- [ ] Weiterleitungen und [[Bedingte Weiterleitung|bedingte Weiterleitungen]]
- [ ] Namensauflösung **hybrid** (lokal ↔ Azure) → Abschnitt 3
- [ ] [[DNS-Richtlinien]]
- [ ] [[DNSSEC]]
- [ ] DHCP-Rolle, Bereiche, Reservierungen → [[DHCP-Server]]
- [ ] IP-Adressprobleme hybrid beheben
- [ ] Hochverfügbarkeit für DHCP → [[DHCP-Failover]]

## 1. DNS mit AD DS
| Zonentyp | Speicherort | Replikation |
|---|---|---|
| Primär (Datei) | `%windir%\System32\dns` | Zonentransfer |
| **AD-integriert** | AD-Partition | mit AD, Multimaster, **sichere dynamische Updates** |
| Sekundär | Kopie, nur lesen | Zonentransfer vom Master |
| Stub | nur NS/SOA/A der Nameserver | Zonentransfer |

Replikationsbereich AD-integriert: alle DNS-Server der **Domäne** (DomainDnsZones), der **Gesamtstruktur** (ForestDnsZones) oder alle DCs der Domäne (Windows-2000-kompatibel).

## 2. Weiterleitungen
| Art | Wann | Befehl (Maschine: EXA-DC01) |
|---|---|---|
| Weiterleitung (Forwarder) | **alle** unbekannten Namen an einen Server (z. B. Provider) | `Add-DnsServerForwarder -IPAddress 1.1.1.1` |
| [[Bedingte Weiterleitung]] | nur **eine** Domäne (z. B. Partnerforest contoso.com) | `Add-DnsServerConditionalForwarderZone -Name contoso.com -MasterServers 192.168.2.10 -ReplicationScope Forest` |
| Stammhinweise | Fallback ohne Weiterleitung | – |
| Stubzone | wie bedingt, aber Nameserver aktualisieren sich selbst | `Add-DnsServerStubZone` |

## 3. Hybride Namensauflösung (lokal ↔ Azure)
| Richtung | Lösung |
|---|---|
| Azure-VMs lösen AD-Namen auf | VNet-DNS-Server = **DCs** (in Azure oder lokal über VPN) |
| Lokale Clients lösen private Azure-Namen (Private Endpoints, `privatelink.file.core.windows.net`) auf | **bedingte Weiterleitung** auf lokalem DNS → [[Azure DNS Private Resolver]] (eingehender Endpunkt) oder DNS-Server-VM in Azure |
| Azure löst lokale Namen auf | Private Resolver: **ausgehender Endpunkt + Weiterleitungsregelsatz** → lokale DCs |
| DNS-Server-VM in Azure fragt Azure | Weiterleitung an **168.63.129.16** (Azure-DNS, nur aus Azure erreichbar) |
- **Private DNS-Zonen** in Azure: Namensauflösung innerhalb verknüpfter VNets (z. B. für Private Endpoints).

## 4. DNS-Richtlinien
Antworten abhängig von **Client-Subnetz, Uhrzeit, Schnittstelle, Abfragetyp** – z. B. Split-Brain (intern andere IP als extern), Geo-Steuerung, Blockieren von Domänen.
```powershell
# Maschine: EXA-DC01 – Clients aus 192.168.10.0/24 bekommen für www eine andere IP
Add-DnsServerClientSubnet -Name Intern -IPv4Subnet 192.168.10.0/24
Add-DnsServerZoneScope -ZoneName example.com -Name InternScope
Add-DnsServerResourceRecord -ZoneName example.com -ZoneScope InternScope -A -Name www -IPv4Address 192.168.1.50
Add-DnsServerQueryResolutionPolicy -Name SplitIntern -Action ALLOW -ClientSubnet 'eq,Intern' `
  -ZoneScope 'InternScope,1' -ZoneName example.com
# Domäne sperren
Add-DnsServerQueryResolutionPolicy -Name BlockMalware -Action IGNORE -FQDN 'EQ,*.boese.example'
```

## 5. DNSSEC
- Signiert Zonen → Clients/Resolver erkennen **gefälschte Antworten** (Cache Poisoning).
- Neue Einträge: **RRSIG** (Signatur), **DNSKEY** (öffentlicher Schlüssel), **DS** (in der Elternzone), **NSEC/NSEC3** (beweist „Name existiert nicht“).
- Schlüssel: **KSK** (signiert die DNSKEYs) und **ZSK** (signiert die Einträge). Rolle **Schlüsselmaster** auf einem DNS-Server.
- Vertrauensanker auf den validierenden Servern; Windows-Clients validieren über die **NRPT** (per GPO).
```powershell
# Maschine: EXA-DC01
Invoke-DnsServerZoneSign -ZoneName example.com -SignWithDefault -Force
Get-DnsServerResourceRecord -ZoneName example.com -RRType DNSKEY
Resolve-DnsName www.example.com -DnssecOk
```

## 6. DHCP
- Bereich, Ausschlüsse, Optionen (003 Router, 006 DNS, 015 Domänenname), **Reservierungen** (MAC → IP), Autorisierung im AD.
- Superbereich, Multicastbereich, Richtlinien (z. B. nach Hersteller-Klasse).
- **In Azure-VNets gibt es keinen eigenen DHCP-Server** – Azure vergibt die Adressen.
```powershell
# Maschine: EXA-DC01 (DHCP)
Add-DhcpServerv4Scope -Name LAN -StartRange 192.168.1.100 -EndRange 192.168.1.199 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -ScopeId 192.168.1.0 -Router 192.168.1.1 -DnsServer 192.168.1.200 -DnsDomain example.com
Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress 192.168.1.150 -ClientId '00-15-5D-01-02-03' -Name Drucker01
```

### DHCP-Failover
| Modus | Verhalten |
|---|---|
| **Lastenausgleich** (Standard) | beide Server verteilen Adressen, Standard 50:50 |
| **Heißer Standby** | ein aktiver, ein Reserveserver (Standard 5 % Reserve-Adressen) |
- Maximal **2 Server** pro Failover-Beziehung, nur IPv4. **MCLT** = maximale Zeit, die ein Partner Leases über die Laufzeit des anderen hinaus verlängern darf.
```powershell
# Maschine: EXA-DC01
Add-DhcpServerv4Failover -Name DC01-DC02 -PartnerServer EXA-DC02 -ScopeId 192.168.1.0 -LoadBalancePercent 50 -SharedSecret 'Geheim!' -AutoStateTransition $true
Get-DhcpServerv4Failover
```

## 7. IP-Probleme hybrid beheben
| Symptom | Prüfen |
|---|---|
| 169.254.x.x (APIPA) | DHCP erreichbar? Relay-Agent (Option 82) im anderen Subnetz? |
| Azure-VM nicht erreichbar | NSG-Regeln, effektive Routen, IP-Flussüberprüfung (Network Watcher) |
| Adresskonflikt lokal ↔ Azure | Adressräume von VNet und LAN dürfen sich **nicht überschneiden** (VPN/Peering) |
| Namensauflösung klappt nur teilweise | VNet-DNS-Einstellung, bedingte Weiterleitungen, `Resolve-DnsName -Server` |
```powershell
# Maschine: betroffener Server
ipconfig /all
Test-NetConnection 10.10.1.4 -Port 3389
Resolve-DnsName exa-srv01.example.com -Server 192.168.1.200
```

## Fallen
- Bedingte Weiterleitung als „AD-integriert“ speichern, sonst kennt sie nur ein Server.
- DNSSEC: Clients prüfen nur, wenn die NRPT es verlangt.
- DHCP-Failover ersetzt das alte Split-Scope-Verfahren – gilt aber nur für IPv4.
- 168.63.129.16 ist aus dem lokalen Netz nicht erreichbar → Private Resolver oder DNS-VM nötig.

## Glossar
[[DNS]] · [[Bedingte Weiterleitung]] · [[DNS-Richtlinien]] · [[DNSSEC]] · [[Azure DNS Private Resolver]] · [[DHCP]] · [[DHCP-Failover]] · [[APIPA]] · [[VNet]] · [[NSG]]
