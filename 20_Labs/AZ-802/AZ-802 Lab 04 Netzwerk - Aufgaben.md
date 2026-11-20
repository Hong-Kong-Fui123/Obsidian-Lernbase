---
tags: [az-802, lab, az-802/netzwerk]
bereich: 04
umgebung: HL
maschinen: [EXA-DC01, EXA-DC02, EXA-DHCP01, EXA-CL01, CON-DC]
status: offen
---
# Lab 04 Netzwerk – Aufgaben
↑ [[AZ-802 04 Netzwerk DNS DHCP]] · Lösungen: [[AZ-802 Lab 04 Netzwerk - Loesungen]]

### A1 – Zonen + Einträge
**Maschine:** EXA-DC01
**Auftrag:** Reverse-Zone für das Lab-Netz (AD-integriert, Forest-weit). A + PTR für `web.example.com` → EXA-SRV01, CNAME `crl` → `web`. Alterung aktivieren.
**Leitfrage:** Was passiert mit statischen Einträgen beim Scavenging?
**Validierung (EXA-CL01):** `Resolve-DnsName crl.example.com` · `Resolve-DnsName <IP-EXA-SRV01>`

### A2 – Weiterleitungen
**Maschine:** EXA-DC01
**Auftrag:** Allgemeine Weiterleitung auf Router/1.1.1.1 (für NAT-Lab), bedingte Weiterleitung contoso.com (falls nicht aus Lab 01).
**Validierung:** `Get-DnsServerForwarder` · `Get-DnsServerZone | ? ZoneType -eq Forwarder`

### A3 – DNS-Richtlinie (Split-Brain)
**Maschine:** EXA-DC01
**Auftrag:** Clients aus Subnetz `10.10.20.0/24` erhalten für `web.example.com` IP `10.10.20.50`, alle anderen die normale IP.
**Leitfrage:** Wozu dient der Zonenbereich?
**Validierung:** `Get-DnsServerQueryResolutionPolicy -ZoneName example.com`

### A4 – DNSSEC (Testzone)
**Maschine:** EXA-DC01
**Auftrag:** Zone `sec.example.lab` anlegen, signieren, Trust Anchor verteilen, NRPT-GPO für Clients.
**Leitfrage:** Wer prüft eigentlich die Signatur – Client oder DNS-Server?
**Validierung (EXA-CL01):** `Resolve-DnsName test.sec.example.lab -DnssecOk` zeigt RRSIG.

### A5 – DHCP + Failover
**Maschinen:** EXA-DHCP01, EXA-DC02
**Auftrag:** DHCP auf EXA-DHCP01 autorisieren, Bereich `Clients` (z. B. .100–.200), Ausschluss .100–.110, Optionen 003/006/015, Reservierung für EXA-CL01. Failover *Hot Standby* mit EXA-DC02, Reserve 10 %.
**Leitfrage:** Was regelt die MCLT?
**Validierung:** `Get-DhcpServerv4Failover -ComputerName EXA-DHCP01` · EXA-CL01: `ipconfig /renew`
