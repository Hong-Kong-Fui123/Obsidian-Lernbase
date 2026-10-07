---
typ: befehle
thema: Windows Server
tags: [befehle, powershell, dns]
quelle: Word-Notizen
status: importiert
---
# Netzwerk und DNS Befehle

Thema: [[Windows Server]] · [[Netzwerk]] · Theorie: [[Glossar/DNS-Records]] · [[Glossar/Forward-Lookup-Zone]] · [[PowerShell Grundlagen]]

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

SOA ist ein [[DNS]]-Eintrag, der für jede DNS-Zone genau einmal existiert. Er sagt, welcher Nameserver die Autorität für diese Zone hat – also wer die "Quelle der Wahrheit" ist.

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

**Diffie-Hellman-Verfahren**: Schlüsselaustausch über unsicheren Kanal (z. B. bei [[IPsec]]) → [[PKI und Zertifikatdienste]] · [[AD-Zertifikatdienste.pdf#page=7|Folie]]

### PowerShell für das verbinden Ordner
net use z: \\exa-srv01\c$
dann auf den Ordner zugreifen
z: 

### PowerShell Pool Festplatte hinzufügen
Theorie: [[Speicherpools]]

New-VirtualDisk -StoragePoolFriendlyName "myPool1" -FriendlyName vDisk4 -ResiliencySettingName parity -ProvisioningType Thin -Size 50GB

### Primäres DNS-Suffix setzen
**Maschine: Client/Server ohne Domäne** (PowerShell als Admin) – aus Schulunterlagen
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "NV Domain" -Value "example.com"
```

## 📄 Unterlagen
- Folien DNS 2025: [[DNS_WindowsServer2025.pdf#page=8|DNS-Rolle installieren]] · [[DNS_WindowsServer2025.pdf#page=9|Zonen verwalten]] · [[DNS_WindowsServer2025.pdf#page=13|Best Practices]]
- Lösung DNS-Übung 1 (viele PowerShell-Befehle): [[DNS_Uebung_1_Loesung.pdf#page=1|Lösung 1–4]] · [[DNS_Uebung_1_Loesung.pdf#page=4|Troubleshooting]]
- Speicher: [[Speicherpool.pdf#page=10|Speicherpool-Cmdlets]]
