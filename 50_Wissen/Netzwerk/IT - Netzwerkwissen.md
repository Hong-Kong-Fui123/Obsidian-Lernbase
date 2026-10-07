---
typ: wissen
thema: Netzwerk
tags: [netzwerk, ipv4, arp]
quelle: Word-Notizen
status: importiert
---
# IT - Netzwerkwissen (Rollen/Features, IPv4-Klassen, ARP)

Thema: [[Netzwerk]] · Siehe auch: [[Netzwerkbefehle und DHCP]] · [[OSI-Modell und Namensauflösung]]

> [!note] Korrigiert 07.10.2026
> Klasse E auf 240–255 korrigiert, Loopback ergänzt, `slmgr -dli` = **Lizenz** (nicht DHCP-Lease).

### Was ist der Unterschied zwischen Features und Rollen?

Features sind Anwendungen/Dienste für den eigenen Bedarf

Rollen sind Anwendungen/Dienste, die für Andere bereitgestellt werden.

### Lizenz (Aktivierung) und Ablaufdatum anzeigen

**Maschine: beliebiger Windows-PC** (CMD)

```cmd
slmgr -dli   :: Lizenzinfos
slmgr -xpr   :: Ablaufdatum der Aktivierung
```

DHCP-**Lease** dagegen: `ipconfig /all` (Client) bzw. `Get-DhcpServerv4Lease` (DHCP-Server) → [[DHCP-Server]]

## IPv4-Adressen, Klassenbezug

A:                    001 - 126

0xxx.xxxx.xxxx.xxxx

B:                    128 - 191

10xx.xxxx.xxxx.xxxx

C:                    192 - 223

110x.xxxx.xxxx.xxxx

D:                    224 - 239 (Multicast-Adressen)

1110.xxxx.xxxx.xxxx

E:  240 - 255 (experimentell)

1111.xxxx.xxxx.xxxx

Loopback 127.0.0.0/8 gehört zu keiner nutzbaren Klasse (127.0.0.1 = localhost).

### Aufrufen der Adapter

ncpa.cpl

## Was ist ARP, welche Funktion und welche Layer/Schicht hat es?

[[ARP]] (Address Resolution Protocol)

LAYER/SCHICHT: Layer 2 (Sicherungsschicht / Data Link Layer)

FUNKTION:

Übersetzt [[IP]]-Adressen in [[MAC]]-Adressen.

ABLAUF:

1. Sender kennt IP-Adresse des Ziels, braucht aber MAC-Adresse

2. Sender sendet ARP-Broadcast: "Wer hat die IP x.x.x.x?"

3. Host mit dieser IP antwortet mit seiner MAC-Adresse

4. Sender speichert die Zuordnung (ARP-Cache)

5. Verbindung kann aufgebaut werden

KURZ: IP → MAC-Auflösung mittels Broadcast + Response

netsh interface ipv6 isatap set state enabled

## Was ist TLS?

Transport Layer Security. Weiterentwicklung von [[SSL]].

## 📄 Unterlagen
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=267|IPv4-Adressen]] · [[70-741_Server2016_Netzwerk.pdf#page=184|Private IPv4-Bereiche, NAT]] · [[70-741_Server2016_Netzwerk.pdf#page=283|ISATAP]]
- Buch 70-642: [[70-642_Server2008R2_Netzwerk.pdf#page=61|IPv4-Adressierung]]
- PKI/TLS: [[PKI und Zertifikatdienste]] · [[AD-Zertifikatdienste.pdf#page=9|Kombination symmetrisch/asymmetrisch]]
- Prüfungsfragen: [[Netzwerk_30_Pruefungsfragen.pdf#page=1|F1–6 IPv4]]
