---
typ: wissen
thema: Windows Server
tags: [windows-server, dhcp, netzwerk]
aliases: [DHCP Windows Server, DHCP-Rolle]
quelle: Schulfolien „DHCP unter Windows Server 2025“
status: lernen
---
# DHCP-Server

Thema: [[Windows Server]] · [[Netzwerk]] · Glossar: [[DHCP]] · [[APIPA]]
Siehe auch: [[Netzwerkbefehle und DHCP]] (DORA, ipconfig) · [[Praxisklausur 1 - AD DS DNS DHCP]]

## Begriffe
| Begriff | Bedeutung |
|---|---|
| Scope (Bereich) | IP-Bereich für ein Subnetz |
| Lease | befristete Zuweisung (LAN Standard: **8 Tage**) |
| Ausschlussbereich | Adressen im Scope, die nicht vergeben werden |
| Reservierung | feste IP für eine **MAC**-Adresse |
| Superscope | mehrere Scopes als Einheit |

**DORA:** Discover (Broadcast) → Offer → Request (Broadcast) → Acknowledge
**Erneuerung:** T1 = 50 % (beim eigenen Server) · T2 = 87,5 % (bei jedem Server) · 100 % → neues Discover

## Wichtige Optionen
| Code | Option |
|---|---|
| 003 | Router (Gateway) |
| 006 | DNS-Server |
| 015 | DNS-Domänenname |
| 066/067 | Boot-Server/Boot-Datei (PXE, [[WDS]]) |

## Einrichtung
**Maschine: EXA-DHCP01** (geplant; bis dahin EXA-DC01) – PowerShell als Admin
```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName exa-dhcp01.example.com -IPAddress 192.168.1.230   # IP = Platzhalter
Add-DhcpServerv4Scope -Name "LAN" -StartRange 192.168.1.100 -EndRange 192.168.1.199 -SubnetMask 255.255.255.0 -State Active
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.1.0 -StartRange 192.168.1.100 -EndRange 192.168.1.110
Set-DhcpServerv4OptionValue -ScopeId 192.168.1.0 -Router 192.168.1.1 -DnsServer 192.168.1.200 -DnsDomain example.com
Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress 192.168.1.150 -ClientId "00-11-22-33-44-55"
Get-DhcpServerv4Lease -ScopeId 192.168.1.0
```
> [!warning] Autorisierung
> In der Domäne vergibt ein DHCP-Server erst nach **Autorisierung im AD** Adressen (Schutz vor Rogue-DHCP). Erste Autorisierung: *Organisations-Admins*.

## Hochverfügbarkeit
**DHCP-Failover** (2 Server): **Load Balance** (beide aktiv, z. B. 50/50) oder **Hot Standby** (aktiv/passiv).

> [!question] Selbsttest
> Client bekommt 169.254.x.x. Nenne drei mögliche Ursachen in der Reihenfolge, in der du sie prüfst.

## 📄 Unterlagen
- Folien DHCP 2025: [[DHCP_WindowsServer2025.pdf#page=3|Was ist DHCP?]] · [[DHCP_WindowsServer2025.pdf#page=5|Architektur/Relay]] · [[DHCP_WindowsServer2025.pdf#page=6|DORA]] · [[DHCP_WindowsServer2025.pdf#page=7|Begriffe]] · [[DHCP_WindowsServer2025.pdf#page=8|Optionen]] · [[DHCP_WindowsServer2025.pdf#page=11|Installieren]] · [[DHCP_WindowsServer2025.pdf#page=12|Autorisieren]] · [[DHCP_WindowsServer2025.pdf#page=15|Scope erstellen]] · [[DHCP_WindowsServer2025.pdf#page=17|Ausschluss/Reservierung]] · [[DHCP_WindowsServer2025.pdf#page=18|Lease]] · [[DHCP_WindowsServer2025.pdf#page=21|Failover]] · [[DHCP_WindowsServer2025.pdf#page=22|Sicherheit]] · [[DHCP_WindowsServer2025.pdf#page=23|Troubleshooting]]
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=75|Kap. 2 DHCP]] · [[70-741_Server2016_Netzwerk.pdf#page=80|Bereiche]] · [[70-741_Server2016_Netzwerk.pdf#page=88|Optionen]] · [[70-741_Server2016_Netzwerk.pdf#page=97|Relay-Agent]] · [[70-741_Server2016_Netzwerk.pdf#page=101|Failover]] · [[70-741_Server2016_Netzwerk.pdf#page=112|Fehlerbehebung]]
- Buch 70-642: [[70-642_Server2008R2_Netzwerk.pdf#page=281|Kap. 4 DHCP]]
- Prüfungsfragen: [[Netzwerk_30_Pruefungsfragen.pdf#page=4|F21–30 DNS/DHCP]] · [[Netzwerk_30_Pruefungsfragen.pdf#page=10|Szenario Reservierung]] · [[Netzwerk_10_Pruefungsfragen.pdf#page=3|Szenario Bereich erschöpft]]

**In Azure / hybrid:** [[Azure DNS und DHCP hybrid]] · [[AZ-802 4 Netzwerk DNS DHCP]]
