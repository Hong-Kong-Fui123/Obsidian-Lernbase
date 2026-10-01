---
typ: wissen
thema: Netzwerk
tags: [netzwerk, osi, dns, ipv6]
quelle: Word-Notizen
status: importiert
---
# OSI-Modell und Namensauflösung

Thema: [[Netzwerk]]

# IP-Paket Header

Adressinformation bezüglich der Pakete die versandt werden.

Namensauflösung

Durch den [[DNS]] (Domain Name Service) werden die [www.XXX](http://www.XXX) in [[IP]]-Adressen aufgelöst.

WINS und DNS - alte und aktuelle Namensauflösung

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

netsh advfirewall set allprofiles state off

Einfacheres Passwort

admin-000

[[IPv6]]
Unicast          z.B. Rechner zu Rechner
Multicast        ersetzt den Broadcast vom v4

Anycast         der erste der sich meldet ist Ansprechpartner, z.B. Netze mit mehreren DNS
