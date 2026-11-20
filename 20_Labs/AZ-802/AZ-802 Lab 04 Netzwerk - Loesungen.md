---
tags: [az-802, loesung, az-802/netzwerk]
bereich: 04
---
# Lab 04 Netzwerk – Lösungen
↑ [[AZ-802 Lab 04 Netzwerk - Aufgaben]]

### A1
- Statische Einträge haben keinen Zeitstempel → werden **nicht** aufgeräumt.
```powershell
# EXA-DC01 (Netz anpassen)
Add-DnsServerPrimaryZone -NetworkId "10.10.10.0/24" -ReplicationScope Forest
Add-DnsServerResourceRecordA -ZoneName example.com -Name web -IPv4Address 10.10.10.21 -CreatePtr
Add-DnsServerResourceRecordCName -ZoneName example.com -Name crl -HostNameAlias web.example.com
Set-DnsServerScavenging -ScavengingState $true -ScavengingInterval 7.00:00:00 -ApplyOnAllZones
```

### A2
```powershell
# EXA-DC01
Set-DnsServerForwarder -IPAddress 192.168.100.1
Add-DnsServerConditionalForwarderZone -Name contoso.com -MasterServers <IP-CON-DC> -ReplicationScope Forest
```

### A3
- Zonenbereich = zweite „Version“ der Zone mit eigenen Einträgen.
```powershell
# EXA-DC01
Add-DnsServerClientSubnet -Name Aussenstelle -IPv4Subnet 10.10.20.0/24
Add-DnsServerZoneScope -ZoneName example.com -Name AussenstelleScope
Add-DnsServerResourceRecord -ZoneName example.com -A -Name web -IPv4Address 10.10.20.50 -ZoneScope AussenstelleScope
Add-DnsServerQueryResolutionPolicy -Name SplitAussen -Action ALLOW -ClientSubnet "eq,Aussenstelle" -ZoneScope "AussenstelleScope,1" -ZoneName example.com
```

### A4
- Der **DNS-Server (Resolver)** validiert; Client verlangt Validierung per NRPT und vertraut dem AD-Bit.
```powershell
# EXA-DC01
Add-DnsServerPrimaryZone -Name sec.example.lab -ReplicationScope Domain
Add-DnsServerResourceRecordA -ZoneName sec.example.lab -Name test -IPv4Address 10.10.10.99
Invoke-DnsServerZoneSign -ZoneName sec.example.lab -SignWithDefault -Force
Get-DnsServerTrustAnchor -Name sec.example.lab
# NRPT: GPO > Computerkonfiguration > Richtlinien > Windows-Einstellungen > Namensauflösungsrichtlinie → Suffix .sec.example.lab, DNSSEC aktivieren + Validierung erfordern
```

### A5
- MCLT = max. Zeit, die ein Partner Leases über den bekannten Stand des anderen hinaus verlängern darf; bestimmt auch Übernahme nach Partnerausfall.
```powershell
# EXA-DHCP01
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName exa-dhcp01.example.com
Add-DhcpServerv4Scope -Name Clients -StartRange 10.10.10.100 -EndRange 10.10.10.200 -SubnetMask 255.255.255.0
Add-DhcpServerv4ExclusionRange -ScopeId 10.10.10.0 -StartRange 10.10.10.100 -EndRange 10.10.10.110
Set-DhcpServerv4OptionValue -ScopeId 10.10.10.0 -Router 10.10.10.1 -DnsServer 10.10.10.10 -DnsDomain example.com
Add-DhcpServerv4Reservation -ScopeId 10.10.10.0 -IPAddress 10.10.10.150 -ClientId <MAC-EXA-CL01> -Name EXA-CL01
# EXA-DC02: DHCP-Rolle installieren + autorisieren, dann EXA-DHCP01:
Add-DhcpServerv4Failover -Name HQ-Failover -PartnerServer exa-dc02.example.com -ScopeId 10.10.10.0 -ServerRole Active -ReservePercent 10 -SharedSecret "Lab!Secret1"
```
