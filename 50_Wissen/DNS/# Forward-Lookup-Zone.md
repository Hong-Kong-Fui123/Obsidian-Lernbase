---
typ: glossar
begriff: Forward-Lookup-Zone
synonyme: [Forward Zone, Vorwärtssuchzone]
thema: "[[DNS]]"
tags: [glossar, dns, netzwerk, windows-server]
erstellt: 2026-10-06
---

# Forward-Lookup-Zone

**Definition:** DNS-Zone, die Namen in IP-Adressen auflöst (Name → IP).

## Inhalt
Enthält [[DNS-Record]]s: SOA, NS, A, AAAA, CNAME, MX, SRV, TXT

## Zonentypen
| Typ | Beschreibung |
|---|---|
| Primär | Beschreibbare Originalkopie |
| Sekundär | Schreibgeschützte Kopie (Zonentransfer) |
| Stub | Nur SOA/NS/A der zuständigen Server |
| AD-integriert | In [[Active Directory]] gespeichert, Replikation über AD |

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
[[DNS]] · [[DNS-Record]] · [[Reverse-Lookup-Zone]] · [[Active Directory]]