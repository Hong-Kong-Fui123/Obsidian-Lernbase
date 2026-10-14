---
typ: wissen
thema: Netzwerk
tags: [netzwerk, osi, dns, ipv6]
quelle: Word-Notizen
status: importiert
---
# OSI-Modell und Namensauflösung

Thema: [[Netzwerk]] · Vertiefung: [[DNS vs mDNS]] · [[DNS-Records]]

# IP-Paket Header

Adressinformation bezüglich der Pakete die versandt werden.

Namensauflösung

Durch den [[DNS]] (Domain Name Service) werden die [www.XXX](http://www.XXX) in [[IP]]-Adressen aufgelöst.

WINS und DNS – alte und aktuelle Namensauflösung. Windows Server 2025 ist die **letzte** Version mit WINS → [[DNS_WindowsServer2025.pdf#page=12|Folie „Ende von WINS“]]

[[OSI]] - **„Alle deutschen Studenten trinken verschiedene Sorten Bier“**. Diese Eselsbrücke hilft, die Reihenfolge Anwendung, Darstellung, Sitzung, Transport, Vermittlung, Sicherung und Bitübertragung zu lernen.

**Die 7 Schichten (von 7 nach 1):**

- **A**lle: **A**nwendung (Application - Layer 7)
- **d**eutschen: **D**arstellung (Presentation - Layer 6)
- **S**tudenten: **S**itzung (Session - Layer 5)
- **t**rinken: **T**ransport (Transport - Layer 4)
- **v**erschiedene: **V**ermittlung (Network - Layer 3)
- **S**orten: **S**icherung (Data Link - Layer 2)
- **B**ier: **B**itübertragung (Physical - Layer 1)

**Englischer Standard-Merkspruch (7 bis 1):**
"**A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing"
**A**pplication, **P**resentation, **S**ession, **T**ransport, **N**etwork, **D**ata Link, **P**hysical

**Application Layer** (7)

**Presentation Layer** (6)

**Session Layer** (5)

**Transport Layer** (4)

**Network Layer** (3)

**Data Link Layer** (2)

**Physical Layer** (1)

## IPv6-Adressarten

[[IPv6]]
Unicast          z.B. Rechner zu Rechner
Multicast        ersetzt den Broadcast vom v4
Anycast         der erste der sich meldet ist Ansprechpartner, z.B. Netze mit mehreren DNS

## Lab-Schnipsel (nur Übungsumgebung!)
- Firewall aus – **Maschine: Lab-VM** (CMD als Admin): `netsh advfirewall set allprofiles state off`
- Lab-Passwort: `admin-000`

## 📄 Unterlagen
- Buch 70-642: [[70-642_Server2008R2_Netzwerk.pdf#page=22|Grundlagen Windows-Netzwerke (OSI)]] · [[70-642_Server2008R2_Netzwerk.pdf#page=106|IPv6-Adressierung]] · [[70-642_Server2008R2_Netzwerk.pdf#page=131|Namensauflösung]]
- Folien: [[Namensaufloesung_WindowsServer2025.pdf#page=8|Windows-Fallback-Reihenfolge]] · [[DNS_WindowsServer2025.pdf#page=3|Was ist Namensauflösung?]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=276|IPv6 im Überblick]]
- Prüfungsfragen: [[Netzwerk_30_Pruefungsfragen.pdf#page=2|F7–13 IPv6]]
