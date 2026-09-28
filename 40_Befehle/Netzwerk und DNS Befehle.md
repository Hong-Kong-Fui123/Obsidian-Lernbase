---
typ: befehle
thema: Windows Server
tags: [befehle, powershell, dns]
quelle: Word-Notizen
status: importiert
---
# Netzwerk und DNS Befehle

Thema: [[Windows Server]] · [[Netzwerk]]

### Löschen Cache Namensauflösung

nbtstat -R

### mmc-Console öffnen und Snap-in hinzufügen

Win+R  >>  mmc eintippen >> Datei >> Snap-In hinzufügen

### DNS-Cache löschen

ipconfig /flushdns

### Name in der DNS registrieren

ipconfig /registerdns

### Anschluss auf dem Client für DNS rausfiltern

Get-DnsClient -InterfaceAlias

oder

Get-NetAdapter

### Ändern des DNS-Servers

Set-DnsClientServerAddress -InterfaceIndex [Nr.] -ServerAddresses [DNS-Server-IP]

### Information über Adapter

Get-NetAdapter

## Was ist SOA (Start of Authority) Autoritätsüberprüfung

SOA ist ein DNS-Eintrag, der für jede DNS-Zone genau einmal existiert. Er sagt, welcher Nameserver die Autorität für diese Zone hat – also wer die "Quelle der Wahrheit" ist.

**Wofür brauchst du es:**

Definiert den primären Nameserver

Regelt, wie sekundäre Nameserver die Zone synchronisieren (Refresh/Retry)

Zeigt Administratorkontakt für die Zone

**Das Wichtigste für die Prüfung:**
Serial-Nummer hochzählen, wenn du Einträge änderst – sonst wissen andere Nameserver nicht, dass es Updates gibt.

### Auslese-Einstellungen bei Nslookup ändern

nslookup eingeben und dann kann man mit set all die Auswahl sehen.

Z.B. Mail-Server auslesen set query=MX [Website]

### DHCPv6 in PowerShell erlauben

Set-NetIPInterface -InterfaceAlias "Privat2" -DHCP Enabled

### Ipconfig Hilfe anzeigen lassen

IPCONFIG -?

### Statische IP einrichten

New-NetIPAddress -InterfaceAlias Privat2 -IPAddress 192.168.1.220 -PrefixLength 24 -DefaultGateway 192.168.1.1

### DNS-Server per PowerShell öffnen.

dnsmgmt.msc

Diffie-Hillmann Verfahren

### PowerShell für das verbinden Ordner
net use z: \\exa-srv01\c$
dann auf den Ordner zugreifen
z: 
