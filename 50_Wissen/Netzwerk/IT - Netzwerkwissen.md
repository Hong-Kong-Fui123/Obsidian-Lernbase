---
typ: wissen
thema: Netzwerk
tags: [netzwerk, ipv4, arp]
quelle: Word-Notizen
status: importiert
---
# IT - Netzwerkwissen (Rollen/Features, IPv4-Klassen, ARP)

Thema: [[Netzwerk]]

> [!warning] Korrekturen
> - Klasse E: 240–255 (nicht 240–247), Binär `1111xxxx`
> - Klasse D/E standen doppelt – bitte doppelte Zeilen löschen
> - 127.x.x.x (Loopback) gehört zu keiner nutzbaren Klasse

### Was ist der Unterschied zwischen Features und Rollen?

Features sind Anwendungen/Dienste für den eigenen Bedarf

Rollen sind Anwendungen/Dienste, die für Andere bereitgestellt werden.

### Wie lautet der PowerShell Befehl für die Leasedauer in Windows

slmgr -dli

## IPv4-Adressen, Klassenbezug

A:                    001 - 126

0xxx.xxxx.xxxx.xxxx

B:                    128 - 191

10xx.xxxx.xxxx.xxxx

C:                    192 - 223

110x.xxxx.xxxx.xxxx

D:                    224 - 239 (Multicast-Adressen)

1110.xxxx.xxxx.xxxx

E:                    240 - 247

1111.10111. xxxx.xxxx

### Aufrufen der Adapter

ncpa.cpl

## Was ist ARP, welche Funktion und welche Layer/Schicht hat es?

ARP (Address Resolution Protocol)

LAYER/SCHICHT: Layer 2 (Sicherungsschicht / Data Link Layer)

FUNKTION:

Übersetzt IP-Adressen in MAC-Adressen.

ABLAUF:

1. Sender kennt IP-Adresse des Ziels, braucht aber MAC-Adresse

2. Sender sendet ARP-Broadcast: "Wer hat die IP x.x.x.x?"

3. Host mit dieser IP antwortet mit seiner MAC-Adresse

4. Sender speichert die Zuordnung (ARP-Cache)

5. Verbindung kann aufgebaut werden

KURZ: IP → MAC-Auflösung mittels Broadcast + Response

netsh interface ipv6 isatap set state enabled

## Was ist TLS?

Transport Layer Security. Weiterentwicklung von SSL.
