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
- VPN-Anmeldung → [[Notizen]]
- WLAN-Enterprise / 802.1X (mit PEAP-MSCHAPv2 oder EAP-TLS)
- Switch-Port-Authentifizierung

## Merksatz
Viele Zugangsgeräte, **ein** zentraler Prüfer → Benutzer nur einmal im AD pflegen.

### PowerShell Zertifikat ohne CA
ServerSeite
$certname = "exa-srv01.example.com"
New-SelfSignedCertificate -Subject "CN=$certname" -DnsName "exa-srv01.example.com" -FriendlyName "myVPNServer" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256

Version von Tillmann
$cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new("\\exa-srv01\certs\exa-srv01-vpn.cer")  
dann testen.
Test-Certificate -Cert $cert
### Abfrage der Sperrliste abstellen
in der Regedit: Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SstpSvc\Parameters
dann neu erstellen DWORD-Wert (32-Bit), Name: NoCertRevocationCheck und den Wert auf 1 stellen

Unterschied zwischen DN
🌐 DNS vs. mDNS > [!abstract] Kurz gesagt > **DNS** übersetzt weltweit Hostnamen in IP-Adressen über zentrale Server. > **mDNS** löst Namen im lokalen Netz auf – ganz ohne DNS-Server. --- ## 📋 Vergleich | Merkmal | DNS | mDNS | | ---------------- | ------------------------------- | ----------------------------------- | | **Name** | Domain Name System | Multicast DNS | | **Reichweite** | Internet / Firmennetz | Nur lokales Subnetz (nicht routbar) | | **Struktur** | Zentral, hierarchisch | Dezentral | | **Server nötig** | ✅ Ja | ❌ Nein | | **Port** | `53` UDP/TCP | `5353` UDP | | **Adressierung** | Unicast an DNS-Server | Multicast `224.0.0.251` / `ff02::fb` | | **Domain** | `example.com` | `.local` → `drucker.local` | | **Software** | BIND, Windows DNS, Pi-hole | Bonjour, Avahi, Windows 10+