---
typ: wissen
thema: Netzwerk
tags: [netzwerk, dhcp, cmd]
quelle: Word-Notizen
status: importiert
---
# Netzwerkbefehle, CIDR, APIPA, DHCP

Thema: [[Netzwerk]] · DHCP vertieft: [[DHCP-Server]]

> [!note] Korrigiert 07.10.2026
> `ping /all` → `ipconfig /all`, `arp -b` → `arp -d`, APIPA-Bereich ergänzt.

# Ping durch Firewall zulassen.

**Maschine: Client/Server** (CMD) – Ping und Netzwerkfehler

```cmd
ping 192.168.1.200
ipconfig /all
arp -a          :: ARP-Cache anzeigen
arp -d          :: ARP-Cache löschen (Admin)
tracert 8.8.8.8 :: Weg der Pakete verfolgen
```

Ping durch die Firewall zulassen – **Maschine: Ziel-PC** (PowerShell als Admin):
```powershell
Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In
```

## CIDR - Classless InterDomain Routing

Die Nummer für die Feststellung des Subnetzmaskensystems z.B. /24 /25

APIPA-Adressen - **Automatic Private [[IP]] Addressing**
Sollte keine Antwort vom [[DHCP]] kommen, nimmt der Computer diese Adressen: **169.254.0.0/16**.

Routen

Routing Befehl
netsh interface ipv4 set interface „EthernetX“ forwarding=enabled

# ipconfig /release

löscht IP-Adressen

# ipconfig /renew

erneuert IP-Adressen

# DORA-Prinzip beim DHCP

**D**iscover - Boradcast zur allg. DHCP-Verfügbarkeit

**O**ffer - alle DHCP-Server schicken ein IP-Angebot

**R**equest - Client such bestes Angebot aus, andere zurückgewiesen.

**A**cknowledge - DHCP-Server bestätigt Angebot und wird gültig.

Defender ausstellen

## 📄 Unterlagen
- Folien DHCP: [[DHCP_WindowsServer2025.pdf#page=6|DORA]] · [[DHCP_WindowsServer2025.pdf#page=18|Lease T1/T2]] · [[DHCP_WindowsServer2025.pdf#page=23|Troubleshooting]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=269|IPv4-Subnetze (CIDR)]] · [[70-741_Server2016_Netzwerk.pdf#page=288|Routing]]
- Buch 70-642: [[70-642_Server2008R2_Netzwerk.pdf#page=61|IPv4-Adressierung]] · [[70-642_Server2008R2_Netzwerk.pdf#page=323|Routing]]
- Prüfungsfragen: [[Netzwerk_30_Pruefungsfragen.pdf#page=1|F1–6 IPv4]] · [[Netzwerk_30_Pruefungsfragen.pdf#page=8|Szenarien Routing]]
