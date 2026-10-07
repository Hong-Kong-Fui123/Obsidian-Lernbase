---
typ: wissen
thema: Netzwerk
tags: [netzwerk, authentifizierung, windows-server, radius, nps]
aliases: [RADIUS-Server, NPS-Server]
quelle: 00_Inbox/Notizen
status: lernen
---
# RADIUS und NPS

Thema: [[Netzwerk]] · [[Windows Server]] · Glossar: [[RADIUS]] · [[NPS]]

**Remote Authentication Dial-In User Service** – zentraler Server für **AAA**:

| A | Bedeutung | Frage |
|---|---|---|
| Authentication | Authentifizierung | Wer bist du? |
| Authorization | Autorisierung | Was darfst du? |
| Accounting | Protokollierung | Was hast du gemacht? |

## Beteiligte
| Rolle | Beispiel |
|---|---|
| Client/Supplicant | Laptop des Benutzers |
| NAS (Network **Access** Server) / RADIUS-Client | [[VPN]]-Server ([[RRAS]]), [[WLAN]]-AP, Switch |
| RADIUS-Server | Windows: **[[NPS]]** (Network Policy Server) |
| Benutzerdatenbank | [[AD\|Active Directory]] |

> [!warning] Verwechslungsgefahr
> NAS heißt hier **Network Access Server** – nicht [[NAS]] (Network Attached Storage).

Ablauf: Client → NAS → RADIUS-Server prüft gegen AD → Accept/Reject → NAS lässt rein oder nicht.

## Technik
- Ports: **[[UDP]] 1812** (Auth), **UDP 1813** (Accounting); alt: 1645/1646
- NAS und Server teilen ein **Shared Secret**
- Verschlüsselt nur das Passwort-Feld, nicht das ganze Paket
- Alternative (Cisco): **TACACS+**, [[TCP]] 49, verschlüsselt komplettes Paket
- **RADIUS-Proxy**: leitet Anfragen je nach Realm/Standort an RADIUS-Servergruppen weiter

## Einsatz
- VPN-Anmeldung → [[DirectAccess_vs_VPN#VPN-Protokolle – Übersicht|VPN-Protokolle]] · Übung: [[Lab VPN SSTP mit MS-CHAPv2]]
- WLAN-Enterprise / 802.1X (mit PEAP-[[MS-CHAPv2]] oder EAP-TLS)
- Switch-Port-Authentifizierung

## Merksatz
Viele Zugangsgeräte, **ein** zentraler Prüfer → Benutzer nur einmal im AD pflegen.

## 📄 Unterlagen
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=233|NPS / RADIUS konfigurieren]] · [[70-741_Server2016_Netzwerk.pdf#page=237|RADIUS-Proxy]] · [[70-741_Server2016_Netzwerk.pdf#page=244|Accounting]] · [[70-741_Server2016_Netzwerk.pdf#page=249|NPS-Richtlinien]] · [[70-741_Server2016_Netzwerk.pdf#page=259|Zertifikate mit NPS]]
- Buch 70-642: [[70-642_Server2008R2_Netzwerk.pdf#page=386|NPS konfigurieren]]
- Prüfungsfragen: [[VPN-RADIUS_15_Pruefungsfragen.pdf#page=2|F6–12 RADIUS/NPS]] · [[VPN-RADIUS_15_Pruefungsfragen.pdf#page=3|F13–15 RADIUS-Proxy]] · [[VPN-RADIUS_15_Pruefungsfragen.pdf#page=5|Szenarien 5–8]] · [[VPN-RADIUS_15_Pruefungsfragen_Loesung.pdf#page=7|Lösungen]]
