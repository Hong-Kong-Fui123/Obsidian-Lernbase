---
aliases: [Clustering, NLB, Failover Cluster, Hochverfügbarkeit]
tags: [thema, windows-server, hochverfuegbarkeit, exam]
bereich: Windows Server
modul: Selbstlernmodul Windows Server / AZ-802
erstellt: 2026-10-14
---

# Cluster und Failover (Windows Server)

> [!summary] Kernidee
> - **Hochverfügbarkeit (HA):** Dienst läuft weiter, wenn ein Server ausfällt.
> - **Zwei Werkzeuge:** [[NLB]] (Last verteilen, zustandslos) und [[Failover-Cluster]] (Dienst übernehmen, zustandsbehaftet).
> - **Nicht kombinierbar:** NLB und Failover-Clustering nie auf demselben Server.

## 1. NLB vs. Failover-Cluster

| Merkmal | [[NLB]] | [[Failover-Cluster]] |
|---|---|---|
| Ziel | Last verteilen + Ausfall abfangen | Ausfall abfangen (Rolle wandert) |
| Aktive Knoten | alle gleichzeitig (Aktiv/Aktiv) | meist einer pro Rolle (Aktiv/Passiv) |
| Daten | jeder Knoten eigene Kopie | [[Shared Storage]] / [[CSV]] |
| Typische Dienste | IIS, Web, VPN, RDS-Gateway | SQL, Dateiserver, Hyper-V-VMs, DHCP |
| Max. Knoten | 32 | 64 |
| Ausfallerkennung | [[Heartbeat]] + [[Konvergenz]] | [[Heartbeat]] + [[Quorum]] |
| Lab-Bezug | EXA-WEB01 + EXA-WEB02 | EXA-DB01 + EXA-DB02 / Hyper-V |

## 2. NLB-Assistent „Cluster Parameters" – jede Auswahl erklärt

Screenshot: *New Cluster : Cluster Parameters*

| Feld | Wert (Beispiel) | Bedeutung | Worauf achten |
|---|---|---|---|
| IP address | `192.168.1.100` | [[Cluster-IP]] (virtuelle IP). Alle Knoten antworten darauf. | Statisch, freie IP, gleiches Subnetz wie Knoten. Wird auf **jeder** NLB-Netzwerkkarte gebunden. |
| Subnet mask | `255.255.255.0` | Maske der Cluster-IP (/24) | Automatisch übernommen, muss zum Netz passen. |
| Full Internet name | `www.example.com` | [[FQDN]] des Clusters | Rein informativ! **A-Record in [[DNS]] muss manuell angelegt werden.** |
| Network address | `03-bf-c0-a8-01-64` | [[Cluster-MAC]], aus der IP berechnet | Nicht editierbar. Präfix verrät den Modus (siehe unten). |

### MAC-Adresse entschlüsseln

```
03-bf  -  c0 . a8 . 01 . 64
Präfix    192 . 168 .  1 . 100   (Hex → Dezimal)
```

| Modus | MAC-Präfix | Beispiel für 192.168.1.100 |
|---|---|---|
| [[Unicast]] | `02-BF` | `02-bf-c0-a8-01-64` |
| [[Multicast]] | `03-BF` | `03-bf-c0-a8-01-64` |
| [[IGMP-Multicast]] | `01-00-5E-7F` | `01-00-5e-7f-01-64` (nur letzte 2 Oktette) |

### Cluster operation mode

| Modus | Funktionsweise | Vorteil | Nachteil | Einsatz |
|---|---|---|---|---|
| **Unicast** | Cluster-MAC **ersetzt** die echte MAC der NIC | Funktioniert mit jedem Router/Switch | Knoten können über diese NIC nicht miteinander reden → **2. NIC nötig**; [[Switch-Flooding]] | Altnetze, Standardmodus |
| **Multicast** *(gewählt)* | Cluster-MAC wird **zusätzlich** zur echten MAC gebunden | 1 NIC reicht, Knoten erreichbar | Router muss Unicast-IP → Multicast-MAC akzeptieren (oft **statischer ARP-Eintrag** nötig); Flooding | Gängig, auch im Lab |
| **IGMP multicast** | Wie Multicast + Knoten senden [[IGMP]]-Join | Switch mit [[IGMP-Snooping]] leitet nur an NLB-Ports → **kein Flooding** | Switch muss IGMP-Snooping können | Produktiv-Netze mit Managed Switches |

> [!warning] Hyper-V-Lab
> - Unicast-NLB in VMs: **MAC-Spoofing** an der VM-NIC aktivieren, sonst kommt kein Verkehr an.
> - Multicast im Lab: meist ohne Zusatz lauffähig (Hyper-V-vSwitch flutet).

## 3. Weitere NLB-Begriffe

- [[Port Rule]] – welche Ports/Protokolle verteilt werden (z. B. TCP 80, 443).
- [[Affinity]] – Sitzungsbindung:
  - **None:** jede Anfrage beliebiger Knoten (zustandslos).
  - **Single:** gleiche Client-IP → gleicher Knoten (Standard, für Sitzungen/HTTPS).
  - **Network (Class C):** gleiches /24-Netz → gleicher Knoten (Proxy-Farmen).
- **Host Priority** – eindeutige ID 1–32; niedrigste Zahl verarbeitet nicht verteilten Verkehr.
- **Drainstop** – Knoten nimmt keine neuen Verbindungen an, bestehende laufen aus (Wartung).

## 4. Failover-Cluster – Kernbegriffe

| Begriff | Kurz |
|---|---|
| [[Quorum]] | Mehrheitsabstimmung: Cluster läuft nur, wenn > 50 % Stimmen online → verhindert [[Split-Brain]]. |
| [[Witness]] | Zusätzliche Stimme: Disk-, File-Share- oder Cloud-Witness (Azure). |
| [[CSV]] | Cluster Shared Volume – alle Knoten greifen gleichzeitig auf ein Volume zu (Hyper-V). |
| [[CNO]] (Cluster Name Object) | Computerkonto des Clusters im [[AD|Active Directory]]. |
| Clusterrolle | Hochverfügbarer Dienst (z. B. Dateiserver), wandert bei Ausfall (**Failover**) und zurück (**Failback**). |
| Cluster-Validierung | `Test-Cluster` prüft Hardware/Netz/Storage vor dem Bau. Pflicht für Support. |

### Quorum-Faustregel

| Knotenanzahl | Empfehlung |
|---|---|
| gerade (2, 4) | Knoten + [[Witness]] → ungerade Stimmenzahl |
| ungerade (3, 5) | Knotenmehrheit (Witness optional, Dynamic Quorum regelt) |
| Hybrid/Azure ([[AZ-802 Übersicht|AZ-802]]) | **Cloud Witness** |

### Vertiefung Schule (15.10.2026)
- Theorie: [[Failovercluster]] (Quorum, Zeugen, CSV, CNO/VCO, CAU, Netzwerk, Server 2025) · [[Hochverfügbarer Dateiserver]] (Rollentypen, Fortlaufende Verfügbarkeit, Failback)
- Praxis: [[Lab Failovercluster Dateiserver]] (iSCSI + 3 Knoten + FS-Cluster)
- VMs im Cluster verschieben: [[Hyper-V Livemigration]] (Live-, Shared-Nothing-, Speicher-, Schnellmigration)
- PDFs: [[Failovercluster_12_Fragen.pdf|Fragen A1–A12]] · [[Failovercluster_12_Fragen_Loesung.pdf|Lösungen + Ergänzungen]] · [[Uebung_Failovercluster.pdf|Übung]] · [[Uebung_Failovercluster_Loesung.pdf|Übung mit Lösung]]

## 5. Befehle

### NLB (Lab: EXA-WEB01 + EXA-WEB02)

```powershell
# Maschine: Hyper-V-Host – nur bei Unicast nötig
Set-VMNetworkAdapter -VMName EXA-WEB01,EXA-WEB02 -MacAddressSpoofing On

# Maschine: EXA-WEB01 und EXA-WEB02
Install-WindowsFeature NLB -IncludeManagementTools

# Maschine: EXA-WEB01 – Cluster erstellen
New-NlbCluster -InterfaceName "Ethernet" -ClusterName "www.example.com" `
  -ClusterPrimaryIP 192.168.1.100 -SubnetMask 255.255.255.0 -OperationMode Multicast

# Maschine: EXA-WEB01 – zweiten Knoten hinzufügen
Get-NlbCluster | Add-NlbClusterNode -NewNodeName EXA-WEB02 -NewNodeInterface "Ethernet"

# Maschine: EXA-WEB01 – Standardregel ersetzen: nur HTTP/HTTPS, Affinity Single
Get-NlbClusterPortRule | Remove-NlbClusterPortRule -Force
Add-NlbClusterPortRule -StartPort 80  -EndPort 80  -Protocol Tcp -Affinity Single
Add-NlbClusterPortRule -StartPort 443 -EndPort 443 -Protocol Tcp -Affinity Single

# Maschine: EXA-DC01 – DNS-Eintrag (NLB legt ihn NICHT an)
Add-DnsServerResourceRecordA -ZoneName "example.com" -Name "www" -IPv4Address 192.168.1.100
```

### Failover-Cluster (Lab: EXA-DB01 + EXA-DB02)

```powershell
# Maschine: EXA-DB01 und EXA-DB02
Install-WindowsFeature Failover-Clustering -IncludeManagementTools

# Maschine: EXA-DB01 – validieren, dann bauen
Test-Cluster -Node EXA-DB01,EXA-DB02
New-Cluster -Name EXA-CL01 -Node EXA-DB01,EXA-DB02 -StaticAddress 192.168.1.110

# Maschine: EXA-DC01 – Freigabe für File-Share-Witness (CNO EXA-CL01$ braucht Vollzugriff)
New-Item C:\Witness -ItemType Directory
New-SmbShare -Name Witness -Path C:\Witness -FullAccess "EXAMPLE\EXA-CL01$"

# Maschine: EXA-DB01 – Quorum setzen
Set-ClusterQuorum -Cluster EXA-CL01 -FileShareWitness \\EXA-DC01\Witness
```

## 6. Aufgaben (Exam-Format)

**A1** – Die Cluster-MAC lautet `03-bf-0a-00-00-32`. Welcher Modus, welche Cluster-IP?

**A2** – NLB im Unicast-Modus mit nur einer NIC. EXA-WEB01 kann EXA-WEB02 nicht pingen. Warum? Zwei Lösungen.

**A3** – Webshop mit Warenkorb in der Server-Sitzung. Welche [[Affinity]]? Begründung.

**A4** – 2-Knoten-Failover-Cluster ohne Witness. Ein Knoten fällt aus. Was passiert und warum?

**A5** – Warum kein NLB für einen SQL-Server mit einer Datenbank?

> [!success]- Lösungen
> **A1** `03-bf` → Multicast. `0a.00.00.32` → **10.0.0.50**.
> **A2** Cluster-MAC ersetzt bei Unicast die echte MAC → beide Knoten haben dieselbe MAC, Pakete erreichen sich nicht. Lösung: 2. NIC für Knotenkommunikation **oder** Multicast-Modus.
> **A3** **Single** – gleiche Client-IP bleibt auf gleichem Knoten, Sitzung/Warenkorb bleibt erhalten.
> **A4** 2 Stimmen, 1 weg = 50 % → keine Mehrheit. Mit Dynamic Quorum übersteht der Cluster es oft, ist aber nicht garantiert (abhängig davon, welcher Knoten die Stimme hält). Deshalb Witness → 3 Stimmen.
> **A5** NLB-Knoten haben eigene Daten → Schreibzugriffe wären inkonsistent. Zustandsbehaftete Dienste → Failover-Cluster mit Shared Storage.

## 7. Validierung (PowerShell)

```powershell
# Maschine: EXA-WEB01 – NLB prüfen
Get-NlbCluster | Format-List Name, IPAddress, OperationMode
Get-NlbClusterNode | Format-Table Name, State, HostPriority   # State = Converged
Get-NlbClusterPortRule

# Maschine: EXA-DC01 – DNS-Auflösung
Resolve-DnsName www.example.com   # erwartet 192.168.1.100

# Maschine: Client (z. B. EXA-CL01-PC) – Erreichbarkeit
Test-NetConnection www.example.com -Port 80

# Maschine: EXA-DB01 – Failover-Cluster prüfen
Get-ClusterNode -Cluster EXA-CL01
Get-ClusterQuorum -Cluster EXA-CL01
```

## Verweise

- Voraussetzungen: [[AD|Active Directory]] · [[DNS]] · [[Hyper-V]]
- Verwandt: [[CA]] (HTTPS-Zertifikat auf **allen** NLB-Knoten identisch, SAN = www.example.com) · [[IIS]] · [[iSCSI]] · [[Speicherpools|Storage Spaces / S2D]] · [[Failovercluster]] · [[Hochverfügbarer Dateiserver]] · [[Lab Failovercluster Dateiserver]]
- Glossar: [[NLB]] · [[Failover-Cluster]] · [[Cluster-IP]] · [[Cluster-MAC]] · [[Unicast]] · [[Multicast]] · [[IGMP-Multicast]] · [[IGMP-Snooping]] · [[Affinity]] · [[Port Rule]] · [[Heartbeat]] · [[Konvergenz]] · [[Quorum]] · [[Witness]] · [[Dynamisches Quorum]] · [[CSV]] · [[Split-Brain]] · [[CNO]] · [[VCO]] · [[Clientzugriffspunkt]] · [[Failback]] · [[Bevorzugter Besitzer]] · [[CAU]] · [[SoFS]] · [[Fortlaufende Verfügbarkeit]] · [[SMB-Zeuge]] · [[MPIO]] · [[iSCSI-Target]] · [[iSCSI-Initiator]] · [[ABE]]
- Übersicht: [[00_Glossar-Index]]
