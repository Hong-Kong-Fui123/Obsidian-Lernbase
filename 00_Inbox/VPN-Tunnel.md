---
tags: [netzwerk, authentifizierung, windows-server]
thema: Netzwerk
---
# RADIUS

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
| NAS / RADIUS-Client | VPN-Server, WLAN-AP, Switch |
| RADIUS-Server | Windows: **NPS** (Network Policy Server) |
| Benutzerdatenbank | Active Directory |

Ablauf: Client → NAS → RADIUS-Server prüft gegen AD → Accept/Reject → NAS lässt rein oder nicht.

## Technik
- Ports: **UDP 1812** (Auth), **UDP 1813** (Accounting); alt: 1645/1646
- NAS und Server teilen ein **Shared Secret**
- Verschlüsselt nur das Passwort-Feld, nicht das ganze Paket
- Alternative (Cisco): **TACACS+**, TCP 49, verschlüsselt komplettes Paket

## Einsatz
- VPN-Anmeldung → [[VPN-Tunnel]]
- WLAN-Enterprise / 802.1X (mit PEAP-MSCHAPv2 oder EAP-TLS)
- Switch-Port-Authentifizierung

## Merksatz
Viele Zugangsgeräte, **ein** zentraler Prüfer → Benutzer nur einmal im AD pflegen.