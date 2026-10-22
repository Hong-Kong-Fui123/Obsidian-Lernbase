---
typ: wissen
thema: Netzwerk
tags: [netzwerk, dns, mdns, namensaufloesung]
aliases: [mDNS, LLMNR, Lokale Namensauflösung]
erstellt: 2026-09-30
quelle: 00_Inbox/Notizen
status: lernen
---

# 🌐 DNS vs. mDNS

Thema: [[Netzwerk]] · [[Windows Server]]

> [!abstract] Kurz gesagt
> **[[DNS]]** übersetzt weltweit Hostnamen in [[IP]]-Adressen über zentrale Server.
> **mDNS** löst Namen im lokalen Netz auf – ganz ohne DNS-Server.

## 📖 DNS – Domain Name System

- **Reichweite:** Internet / Firmennetz
- **Struktur:** zentral, hierarchisch (Root → TLD → Domain)
- **Server nötig:** ✅ Ja
- **Port:** `53` UDP/TCP
- **Adressierung:** Unicast an DNS-Server
- **Domain:** `example.com`
- **Software:** BIND, Windows DNS, Pi-hole

> [!info] Ablauf
> Client → DNS-Server → Root → TLD → autoritativer Server → IP zurück

## 📢 mDNS – Multicast DNS

- **Reichweite:** nur lokales Subnetz (nicht routbar)
- **Struktur:** dezentral
- **Server nötig:** ❌ Nein
- **Port:** `5353` UDP
- **Adressierung:** Multicast `224.0.0.251` / `ff02::fb`
- **Domain:** `.local` → `drucker.local`
- **Software:** Bonjour, Avahi, Windows 10+

> [!info] Ablauf
> Client ruft per Multicast ins [[LAN]]: *„Wer ist `xyz.local`?"*
> → Das gemeinte Gerät antwortet selbst mit seiner IP.

## 🔁 Weitere lokale Verfahren (Windows)

| Verfahren | Port | Status |
|---|---|---|
| mDNS | UDP 5353 | Industriestandard, Microsofts Zukunft |
| LLMNR | UDP 5355 (224.0.0.252) | Microsoft (ab Vista), wird abgekündigt |
| NetBIOS-NS | UDP/TCP 137 (Broadcast) | ältestes Verfahren, abgekündigt |

> [!warning] Sicherheit
> LLMNR und NetBIOS-NS vertrauen jedem im Subnetz → **Poisoning-Angriffe** (Angreifer antwortet schneller). Empfehlung: per [[GPO]] deaktivieren.

## 🧠 Merksatz

> [!tip] Eselsbrücke
> - **DNS** = zentrales Telefonbuch des Internets
> - **mDNS** = in den Raum rufen und warten, wer antwortet

## 🔗 Verwandt
- [[DNS-Records]] · [[Forward-Lookup-Zone]] · [[Reverse-Lookup-Zone]]
- [[OSI-Modell und Namensauflösung]]
- [[DHCP]] · [[OSI]]

## 📄 Unterlagen
- Folien Namensauflösung: [[Namensaufloesung_WindowsServer2025.pdf#page=3|Warum lokal?]] · [[Namensaufloesung_WindowsServer2025.pdf#page=4|mDNS]] · [[Namensaufloesung_WindowsServer2025.pdf#page=5|LLMNR]] · [[Namensaufloesung_WindowsServer2025.pdf#page=6|NetBIOS-NS]] · [[Namensaufloesung_WindowsServer2025.pdf#page=7|Vergleich]] · [[Namensaufloesung_WindowsServer2025.pdf#page=8|Fallback-Reihenfolge]] · [[Namensaufloesung_WindowsServer2025.pdf#page=10|Poisoning]] · [[Namensaufloesung_WindowsServer2025.pdf#page=11|Härten]]
- Folien DNS 2025: [[DNS_WindowsServer2025.pdf#page=6|DNS-Abfrageprozess]] · [[DNS_WindowsServer2025.pdf#page=12|Ende von WINS]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=15|Namensauflösung im Überblick]]


