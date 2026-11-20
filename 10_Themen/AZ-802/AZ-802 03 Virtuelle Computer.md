---
aliases: [Hyper-V AZ-802, VMs AZ-802]
tags: [az-802, az-802/vm, thema]
bereich: 03
gewicht: 10–15 %
status: offen
---
# 03 Virtuelle Computer verwalten (10–15 %)
↑ [[AZ-802 MOC]] · Lab: [[AZ-802 Lab 03 Hyper-V - Aufgaben]]

## Prüfungsziele
- [ ] Erweiterter Sitzungsmodus
- [ ] Remote: PowerShell, PowerShell Direct, SSH Direct (Linux)
- [ ] Geschachtelte Virtualisierung
- [ ] VM-Speicher (dynamisch, NUMA)
- [ ] Integrationsdienste
- [ ] Gerätezuweisung (DDA)
- [ ] GPU-Partitionierung
- [ ] Prüfpunkte
- [ ] Hochverfügbarkeit (Cluster, Live-Migration)
- [ ] Virtuelle Festplatten
- [ ] Netzwerkadapter, NIC-Teaming (Host + VM), vSwitch
- [ ] Hyper-V-Replikat
- [ ] Azure-VMs: Speicher, Größe/Skalierungsgruppen, Verfügbarkeitsgruppen/Zonen, JIT/Bastion, Netzwerk

## Kernwissen Hyper-V

### Zugriff auf Gäste
| Methode | Voraussetzung | Netzwerk nötig |
|---|---|---|
| Erweiterte Sitzung | Host-Einstellung + Gast mit RDP-Diensten | nein (VMBus) |
| PowerShell Direct | gleicher Host, Gast Win10/2016+, Gast-Anmeldedaten | **nein** |
| SSH Direct | Linux-Gast, hvsocket | nein |
| PS-Remoting / SSH | IP-Verbindung | ja |
- `Enter-PSSession -VMName EXA-SRV01 -Credential EXAMPLE\Administrator`

### Geschachtelte Virtualisierung
- VM **aus**, `Set-VMProcessor -ExposeVirtualizationExtensions $true`
- Dynamischer RAM aus, MAC-Spoofing an (oder NAT im Gast).

### Speicher
- Dynamischer RAM: Startup / Minimum / Maximum / Puffer. Nicht für alle Workloads (z. B. Exchange/SQL-Empfehlung prüfen).
- NUMA-Spanning; Smart Paging nur beim Neustart.

### Integrationsdienste
- Herunterfahren, Zeitsynchronisierung, Datenaustausch (KVP), Takt, **VSS-Sicherung**, Gastdienste (Datei-Kopie: `Copy-VMFile`).
- DC als VM: Zeitsync-Integration **teilweise** deaktivieren → `w32tm` nutzt Domänenhierarchie.

### Gerätezuweisung & GPU
| Technik | Prinzip | Einschränkung |
|---|---|---|
| DDA (Discrete Device Assignment) | ganzes PCIe-Gerät an 1 VM | keine Live-Migration, kein dyn. RAM |
| GPU-Partitionierung (GPU-P) | GPU teilen zwischen VMs | unterstützte GPU/Treiber, ab Server 2025 Live-Migration möglich |

### Prüfpunkte
| Typ | Technik | Einsatz |
|---|---|---|
| Produktion (Standard) | VSS im Gast, konsistent | Server, DCs |
| Standard | Speicherzustand inkl. RAM | Test/Dev |
- Datei: `.avhdx`. Löschen → Merge. Nicht als Backup-Ersatz.

### Virtuelle Festplatten
| Format/Typ | Merkpunkt |
|---|---|
| VHD | max. 2 TB, veraltet |
| VHDX | bis 64 TB, robust, 4K |
| Feste Größe | beste Leistung |
| Dynamisch | wächst bei Bedarf (Standard) |
| Differenzierend | Parent + Child, Labs |
| Shared VHDX / VHD Set (`.vhds`) | Gastcluster |
- Online vergrößern: SCSI-Controller. `Resize-VHD`, `Optimize-VHD`, `Convert-VHD`.

### Netzwerk
| vSwitch | Verbindung |
|---|---|
| Extern | VM ↔ physisches Netz |
| Intern | VM ↔ Host |
| Privat | nur VMs |
| NAT (`New-NetNat`) | Intern + NAT → Internet fürs Lab |
- Adapter: synthetisch (Standard), Legacy nur Gen1-PXE. Funktionen: VLAN-ID, Bandbreite, MAC-Spoofing, DHCP-/Router-Guard, Port-Mirroring.
- **SET** (Switch Embedded Teaming) = Teaming im vSwitch, empfohlen ab 2016; LBFO für Hyper-V veraltet.
- NIC-Teaming in VM: `Set-VMNetworkAdapter -AllowTeaming On`, max. 2 Adapter, Switch Independent.

### Hochverfügbarkeit
- Failover-Cluster + CSV/S2D; Live-Migration (Kerberos oder CredSSP, SMB empfohlen), Storage-Migration, Quick-Migration.
- VM-Startpriorität, Anti-Affinität, VM-Überwachung.

### Hyper-V-Replikat
- Asynchron, Intervall **30 s / 5 Min / 15 Min**, Port 80 (Kerberos/HTTP) oder 443 (Zertifikat).
- Zusätzliche Wiederherstellungspunkte, App-konsistent per VSS.
- Failover: geplant / Test (keine Unterbrechung) / ungeplant. Cluster: **Hyper-V Replica Broker**.
- Erweitertes Replikat (Kette zu 3. Standort).

## Kernwissen Azure-VMs
| Thema | Merkpunkt |
|---|---|
| Datenträger | OS, temporär (Daten gehen verloren!), Daten; Typen Standard HDD/SSD, Premium SSD (v2), Ultra |
| Größe ändern | ggf. Neustart, Größe muss im Cluster/Region verfügbar sein → sonst Deallocate |
| VM Scale Sets | Auto-Skalierung, Orchestrierung flexibel/einheitlich |
| Verfügbarkeitsgruppe | Fehler-/Updatedomänen im Rechenzentrum, SLA 99,95 % |
| Verfügbarkeitszone | getrennte RZ in Region, SLA 99,99 % |
| JIT | Defender for Cloud öffnet NSG-Port zeitlich begrenzt |
| Bastion | RDP/SSH per Browser, Subnetz **AzureBastionSubnet** (/26+), keine Public-IP an VM |
| Netzwerk | NIC, private/öffentliche IP, NSG an NIC/Subnetz, beschleunigtes Networking |

## Prüfungsfallen
- PowerShell Direct braucht **Gast**-Anmeldedaten, kein Netzwerk.
- Nested: VM muss **ausgeschaltet** sein.
- Replikat ≠ Backup; Testfailover unterbricht nicht.
- Azure-Temp-Disk (`D:`) nie für Daten.
- Verfügbarkeitsgruppe und -zone nicht kombinierbar.

## Leitfragen
1. EXA-SRV01 hat kein Netz mehr. Wie kommst du von Hyper-V-Host per PowerShell drauf?
2. Warum keine Standard-Prüfpunkte auf EXA-DC01?
3. Welchen vSwitch-Typ braucht das Lab für Internet ohne direkten Zugriff aufs Heimnetz?

## Glossar
[[PowerShell Direct]] · [[Hyper-V-Replikat]] · [[SET]] · [[DDA]] · [[Azure Bastion]] · [[JIT-Zugriff]]
