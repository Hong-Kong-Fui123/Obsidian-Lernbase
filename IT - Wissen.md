### Was ist der Unterschied zwischen Features und Rollen?

Features sind Anwendungen/Dienste für den eigenen Bedarf

Rollen sind Anwendungen/Dienste, die für Andere bereitgestellt werden.


# ##Klassenbezug IPv4-Adressen, 

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
D:                    224 - 239 (Multicast-Adressen)
1110.xxxx.xxxx.xxxx
E:                    240 - 247
1111.10111. xxxx.xxxx
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




