### **VPN-Tunnel – Uebersicht**

| Protokoll      | Vollstaendiger Name                                                     | Port/Basis                                     | Verschluesselung                    | Bewertung                                    | Computer<br>Authentif. |
| -------------- | ----------------------------------------------------------------------- | ---------------------------------------------- | ----------------------------------- | -------------------------------------------- | ---------------------- |
| PPTP / MPPE    | Point-to-Point Tunneling Protocol / Microsoft Point-to-Point Encryption | TCP 1723 + GRE (Generic Routing Encapsulation) | MPPE (RC4, bis 128 Bit)             | veraltet, unsicher – nicht mehr nutzen       | Nein                   |
| L2TP (/IPsec)  | Layer 2 Tunneling Protocol (/ Internet Protocol Security)               | UDP 1701, 500, 4500                            | keine eigene → mit IPsec kombiniert | ok, aber NAT-/Firewall-Probleme              | Ja                     |
| SSTP           | Secure Socket Tunneling Protocol                                        | TCP 443 (SSL/TLS)                              | SSL/TLS                             | firewallfreundlich, Windows-lastig           | Ja                     |
| IKEv2 (/IPsec) | Internet Key Exchange version 2 (/ IPsec)                               | UDP 500, 4500                                  | IPsec (AES)                         | modern, stabil, schneller Reconnect (MOBIKE) | Ja                     |
|                |                                                                         |                                                |                                     |                                              |                        |
