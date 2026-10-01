---
typ: wissen
thema: Netzwerk
tags: [netzwerk, dhcp, cmd]
quelle: Word-Notizen
status: importiert
---
# Netzwerkbefehle, CIDR, APIPA, DHCP

Thema: [[Netzwerk]]

> [!warning] Korrekturen
> - `ping /all` und `arp -b` gibt es nicht – gemeint ist `ipconfig /all` bzw. `arp -a`/`arp -d`
> - [[APIPA]]-Bereich: 169.254.0.0/16

# Ping durch Firewall zulassen.

CMD - Ping und Netzwerkfehle

Ping /all

Ping

ipconfig /all
arp -a

arp -b

tracert (Rückverfolgungpakete)

## CIDR - Classless InterDomain Routing

Die Nummer für die Feststellung des Subnetzmaskensystems z.B. /24 /25

APIPA-Adressen - **Automatic Private [[IP]] Addressing**
Sollte keine Antwort vom [[DHCP]] kommen, nimmt der Computer diese Adressen.

Routen

Routing Befehl
netsh interface ipv4 set interface „EthernetX“ forwarding=enabled

# ipconfig /release

löscht IP-Adressen

# ipconfig /renew

erneuert IP-Adressen

# DORA-Prinzip beim DHCP

**D**iscover - Boradcast zur allg. DHCP-Verfügbarkeit

**O**ffer - alle DHCP-Server schicken IP-Angebot (max. 4x)

**R**equest - Client such bestes Angebot aus, andere zurückgewiesen.

**A**cknowledge - DHCP-Server bestätigt Angebot und wird gültig.

Defender ausstellen
