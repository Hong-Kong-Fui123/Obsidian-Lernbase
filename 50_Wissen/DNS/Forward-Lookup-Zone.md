---
typ: glossar
begriff: Forward-Lookup-Zone
synonyme: [Forward Zone, Vorwärtssuchzone]
thema: "[[DNS]]"
tags: [glossar, dns, netzwerk, windows-server]
erstellt: 2026-10-06
aliases: [Forward Lookup Zone, Vorwärtssuchzone]
---

# Forward-Lookup-Zone

**Definition:** DNS-Zone, die Namen in IP-Adressen auflöst (Name → IP).

## Inhalt
Enthält [[DNS-Records|DNS-Records]]: SOA, NS, A, AAAA, CNAME, MX, SRV, TXT

## Zonentypen
| Typ | Beschreibung |
|---|---|
| Primär | Beschreibbare Originalkopie |
| Sekundär | Schreibgeschützte Kopie (Zonentransfer) |
| Stub | Nur SOA/NS/A der zuständigen Server |
| AD-integriert | In [[AD DS Überblick\|Active Directory]] gespeichert, Replikation über AD |

## Befehle
**Anlegen** – Windows Server mit DNS-Rolle (PowerShell):
```powershell
Add-DnsServerPrimaryZone -Name "example.com" -ReplicationScope "Domain"
```

**Anzeigen** – Windows Server mit DNS-Rolle (PowerShell):
```powershell
Get-DnsServerZone
Get-DnsServerResourceRecord -ZoneName "example.com"
```

## Merke
- Pflicht für jede Domäne – ohne Forward-Zone keine Namensauflösung
- AD-integriert → sichere dynamische Updates möglich
- Gegenstück: [[Reverse-Lookup-Zone]]

## Verwandt
[[DNS]] · [[DNS-Records]] · [[Reverse-Lookup-Zone]] · [[DNS vs mDNS]] · [[AD DS Überblick|Active Directory]] · [[Vertrauensstellungen]] (Stub-Zone)

## 📄 Unterlagen
- Folien: [[DNS_WindowsServer2025.pdf#page=7|Zonentypen]] · [[DNS_WindowsServer2025.pdf#page=9|Zonen & Weiterleitungen]] · [[DNS_Einfuehrung_Folien.pdf#page=2|Rekursive Abfrage]] · [[DNS_Einfuehrung_Folien.pdf#page=4|Weiterleitung]]
- Übung 1: [[DNS_Uebung_1.pdf#page=2|Primäre + sekundäre Zone]] · [[DNS_Uebung_1_Loesung.pdf#page=2|Lösung Zonentransfer]]
- Übung 2: [[DNS_Uebung_2.pdf#page=2|Delegierung + Stub-Zone]] · [[DNS_Uebung_2.pdf#page=4|Lösungen]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=43|Primäre Zonen]] · [[70-741_Server2016_Netzwerk.pdf#page=48|Sekundäre Zonen]] · [[70-741_Server2016_Netzwerk.pdf#page=51|Delegierung]] · [[70-741_Server2016_Netzwerk.pdf#page=53|AD-integriert]] · [[70-741_Server2016_Netzwerk.pdf#page=56|Stubzonen]]
- Prüfungsfragen: [[AD-DS_50_Pruefungsfragen.pdf#page=7|F43 DNS-Zonenart für AD]] · [[Netzwerk_10_Pruefungsfragen.pdf#page=2|Szenario bedingte Weiterleitung]]

**In Azure / hybrid:** [[Azure DNS und DHCP hybrid]] · [[AZ-802 4 Netzwerk DNS DHCP]]
