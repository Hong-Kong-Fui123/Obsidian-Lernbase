---
typ: glossar
begriff: Reverse-Lookup-Zone
synonyme: [Reverse Zone, Rückwärtssuchzone]
aliases: [Reverse Lookup Zone, Reverse-Zone]
thema: "[[DNS]]"
tags: [glossar, dns, netzwerk, windows-server]
erstellt: 2026-10-07
---

# Reverse-Lookup-Zone

**Definition:** DNS-Zone, die IP-Adressen in Namen auflöst (IP → Name). Gegenstück zur [[Glossar/Forward-Lookup-Zone]].

## Inhalt
- **PTR**-Einträge (siehe [[Glossar/DNS-Records]])
- Zonenname = Netz-ID **rückwärts** + `in-addr.arpa`
  - Netz `192.168.10.0/24` → Zone `10.168.192.in-addr.arpa`
  - IPv6: `ip6.arpa`

## Befehle
**Anlegen** – Windows Server mit DNS-Rolle (PowerShell):
```powershell
Add-DnsServerPrimaryZone -NetworkId "192.168.10.0/24" -ReplicationScope "Domain"
Add-DnsServerResourceRecordPtr -ZoneName "10.168.192.in-addr.arpa" -Name "30" -PtrDomainName "srv-app01.firma.local"
```

**Testen** – Client (PowerShell / CMD):
```powershell
Resolve-DnsName 192.168.10.30
nslookup 192.168.10.30
```

## Merke
- Kein Muss für Namensauflösung, aber nötig für: Logs/Troubleshooting, manche Dienste (Mailserver-Prüfung), `nslookup` ohne „Unknown“
- PTR-Eintrag automatisch: beim A-Eintrag Häkchen „Zugehörigen PTR-Eintrag erstellen“ – klappt nur, wenn die Reverse-Zone **existiert**

## 📄 Unterlagen
- Übung: [[DNS_Uebung_1.pdf#page=3|DNS-Übung 1 (Reverse-Lookupzone)]] · [[DNS_Uebung_1_Loesung.pdf#page=3|Lösung 10–12 (Reverse)]]
- Folien: [[DNS_WindowsServer2025.pdf#page=7|Zonentypen]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=43|Primäre Zonen (inkl. Reverse)]]

## Verwandt
[[DNS]] · [[Glossar/DNS-Records]] · [[Glossar/Forward-Lookup-Zone]] · [[DNS vs mDNS]]
