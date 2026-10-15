---
typ: wissen
thema: Windows Server
tags: [windows-server, hochverfuegbarkeit, failovercluster, exam]
aliases: [Failover Clustering Grundlagen, Clusterquorum, Quorum und Zeugen]
erstellt: 2026-10-15
status: lernen
quelle: "Schule: Failover Clustering Dateiserver – Fragen A1–A12 + Übung"
---
# Failovercluster – Grundlagen, Quorum, Verwaltung

Thema: [[Cluster und Failover]] · [[Windows Server]] · Dateiserver im Cluster: [[Hochverfügbarer Dateiserver]] · Praxis: [[Lab Failovercluster Dateiserver]]
Unterlagen: [[Failovercluster_12_Fragen.pdf|Fragen A1–A12]] · [[Failovercluster_12_Fragen_Loesung.pdf|Lösungen]] · [[Failovercluster_12_Fragen_Loesung.pdf#page=4|Ergänzungen + Quellen]] · [[Uebung_Failovercluster.pdf|Übung]] · [[Uebung_Failovercluster_Loesung.pdf|Übung mit Lösung]]

> [!summary] Kernidee
> - Mehrere unabhängige Server (**Knoten**) stellen eine **Rolle** gemeinsam hochverfügbar bereit. Fällt der Besitzerknoten aus, übernimmt ein anderer (**Failover**).
> - Das **Quorum** (Stimmenmehrheit) entscheidet, ob der Cluster weiterlaufen darf → kein [[Split-Brain]].
> - Zustandsbehaftete Dienste (Dateiserver, SQL, Hyper-V) → Failovercluster. Zustandslose (Web) → [[NLB]].

## 1. Bausteine
| Baustein | Bedeutung | In der Übung |
|---|---|---|
| Knoten | Server mit Feature *Failover-Clustering* | EXA-SRV01, EXA-SRV02, EXA-SRV04 |
| Clusterrolle | hochverfügbarer Dienst, gehört immer **einem** Knoten | FS-Cluster (Dateiserver) |
| Clusterdatenträger | gemeinsamer Speicher ([[Shared Storage]]), je Datenträger **ein** Besitzer | Cluster Disk 1/2 über [[iSCSI]] |
| [[CSV]] | Datenträger, den **alle** Knoten gleichzeitig nutzen | – (nur für SOFS/Hyper-V) |
| [[CNO]] | Computerkonto des Clusters im [[AD]] | myCluster · 192.168.1.100 |
| [[VCO]] | Computerkonto eines Clientzugriffspunkts | FS-Cluster · 192.168.1.101 |
| Validierung | `Test-Cluster` – Pflicht für Microsoft-Support | Schritt 4 |

Fragen: [[Failovercluster_12_Fragen.pdf#page=1|A1]] · Lösung: [[Failovercluster_12_Fragen_Loesung.pdf#page=1|A1]]

## 2. Quorum und Zeugen
Jeder Knoten hat eine Stimme, der Zeuge ([[Witness]]) ggf. eine weitere. Der Cluster läuft nur mit **mehr als 50 %** der Stimmen.

| Aufbau | Stimmen | 1 Knoten fällt aus | Ergebnis |
|---|---|---|---|
| 2 Knoten, kein Zeuge | 2 | 1 von 2 = 50 % | keine Mehrheit → Risiko Split-Brain |
| 2 Knoten + Zeuge | 3 | 2 von 3 | läuft weiter ✅ |
| 3 Knoten, kein Zeuge (Übung Schritt 7) | 3 | 2 von 3 | läuft weiter ✅ |
| 3 Knoten + Zeuge (Übung Schritt 6) | 4 → dynamischer Zeuge macht 3 daraus | 2 von 3 | läuft weiter ✅ |

### Zeugentypen
| Zeuge | Wo | Voraussetzungen | Typischer Einsatz |
|---|---|---|---|
| **Datenträgerzeuge** | kleiner Clusterdatenträger | > 512 MB, Basisdatenträger, NTFS/ReFS, kein Laufwerksbuchstabe, keine anderen Daten | SAN/iSCSI am selben Standort |
| **Dateifreigabezeuge** | SMB-Freigabe außerhalb des Clusters | SMB 2+, ≥ 5 MB frei, eine Freigabe pro Cluster, kein DFS/replizierter Speicher; ohne Domäne (NAS, Router mit USB) ab Server 2019 | kein gemeinsamer Speicher, mehrere Standorte |
| **Cloudzeuge** | Blob im Azure-Speicherkonto | GPv2-Konto, ausgehend HTTPS 443 | kein dritter Standort, Hybrid/AZ-802 |

### Dynamisches Quorum vs. dynamischer Zeuge
| | [[Dynamisches Quorum]] | Dynamischer Zeuge |
|---|---|---|
| Was wird angepasst? | Stimmen der **Knoten** | Stimme des **Zeugen** |
| Regel | Knoten fällt geordnet aus → verliert seine Stimme | ungerade Knotenstimmen → Zeuge 0, gerade → Zeuge 1 |
| Effekt | „Last Man Standing“: Cluster übersteht Ausfälle nacheinander | Gesamtstimmen bleiben ungerade |
| Prüfen | `NodeWeight` / `DynamicWeight` | `(Get-Cluster).WitnessDynamicWeight` |

> [!tip] Empfehlung
> Microsoft empfiehlt ab Server 2012 R2 **immer** einen Zeugen zu konfigurieren – der dynamische Zeuge entscheidet selbst, ob er mitstimmt.

Fragen: [[Failovercluster_12_Fragen.pdf#page=1|A4]] · [[Failovercluster_12_Fragen.pdf#page=2|A5]] · [[Failovercluster_12_Fragen.pdf#page=3|A9]] · Lösungen: [[Failovercluster_12_Fragen_Loesung.pdf#page=1|A4]] · [[Failovercluster_12_Fragen_Loesung.pdf#page=2|A5]] · [[Failovercluster_12_Fragen_Loesung.pdf#page=3|A9]] · Übung: [[Uebung_Failovercluster_Loesung.pdf#page=4|Schritt 6]] · [[Uebung_Failovercluster_Loesung.pdf#page=5|Schritt 7]]

## 3. Clusterdatenträger vs. CSV
| | Clusterdatenträger | [[CSV]] |
|---|---|---|
| Zugriff | ein Knoten (Besitzer) | alle Knoten gleichzeitig |
| Pfad | eigener Laufwerksbuchstabe | `C:\ClusterStorage\VolumeX` auf jedem Knoten |
| Metadaten | Besitzerknoten | ein **Koordinatorknoten** |
| Pflicht für | – | [[SoFS]] (Scale-Out File Server), üblich für Hyper-V |

Fragen: [[Failovercluster_12_Fragen.pdf#page=2|A7]] · Lösung: [[Failovercluster_12_Fragen_Loesung.pdf#page=2|A7]]

## 4. CNO und VCO im Active Directory
- **[[CNO]]** (Clusternameobjekt) = Computerkonto des Clusters, entsteht bei `New-Cluster`.
- **[[VCO]]** (virtuelles Computerobjekt) = Computerkonto eines Clientzugriffspunkts (z. B. FS-Cluster). Das CNO legt VCOs selbst an.
- Dafür braucht das CNO in der [[OU]] das Recht **„Computerobjekte erstellen“** – oder VCOs werden vorab angelegt (**Prestaging**) und das CNO bekommt Vollzugriff.

Fragen: [[Failovercluster_12_Fragen.pdf#page=2|A8]] · Lösung: [[Failovercluster_12_Fragen_Loesung.pdf#page=2|A8]]

## 5. Cluster-Aware Updating (CAU)
[[CAU]] patcht Knoten nacheinander: Wartungsmodus (Rollen verschieben) → Updates → Neustart → wieder aufnehmen. Die Rollen bleiben online.

| Modus | Wer startet den Updatelauf? | Befehl |
|---|---|---|
| Selbstaktualisierung | CAU-Clusterrolle im Cluster, nach Zeitplan | `Add-CauClusterRole` |
| Remoteaktualisierung | Verwaltungscomputer außerhalb des Clusters | `Invoke-CauRun` |

Verwandt: [[WSUS]] · Fragen: [[Failovercluster_12_Fragen.pdf#page=3|A10]] · Lösung: [[Failovercluster_12_Fragen_Loesung.pdf#page=3|A10]]

## 6. Netzwerk
- Mindestens **zwei getrennte Netze**, kein Single Point of Failure: Client/Cluster + Speicher ([[iSCSI]]) bzw. reiner Clusterverkehr ([[Heartbeat]], CSV-Umleitung).
- Redundante NICs (NIC-Teaming / Switch Embedded Teaming) und Switches. Für iSCSI **[[MPIO]]** statt Teaming.
- Netzwerkrollen im Failovercluster-Manager: Speichernetz *Keine Clusterkommunikation* · Clientnetz *Cluster und Client* · internes Netz *Nur Cluster*.

Fragen: [[Failovercluster_12_Fragen.pdf#page=3|A12]] · Lösung: [[Failovercluster_12_Fragen_Loesung.pdf#page=3|A12]]

## 7. Neu in Windows Server 2025 (Datei/Cluster)
| Bereich | Neuerung |
|---|---|
| SMB | SMB über QUIC jetzt in Standard und Datacenter · Signatur für alle **ausgehenden** Verbindungen Pflicht · NTLM-Blockierung im SMB-Client · Ratenbegrenzung für Anmeldeversuche (standardmäßig an) |
| Speicher | ReFS-Deduplizierung und -Komprimierung · Thin Provisioning für S2D · Storage-Replica-Komprimierung ([[Storage Replica]]) · schnellere NVMe |
| Cluster | Hyper-V-Arbeitsgruppencluster mit Livemigration · Campus-Cluster für S2D (erst mit Update 2025-12, KB5072033) |

> [!warning] Geprüft am 15.10.2026
> „Verbesserungen bei CAU“ aus der Lösung A11 stehen **nicht** in Microsofts Liste „What's new in Windows Server 2025“. Details: [[Failovercluster_12_Fragen_Loesung.pdf#page=4|Ergänzungsseite]].

Fragen: [[Failovercluster_12_Fragen.pdf#page=3|A11]] · Lösung: [[Failovercluster_12_Fragen_Loesung.pdf#page=3|A11]]

## 8. Befehle zum Prüfen
```powershell
# Maschine: EXA-DC01 (RSAT-Clustering installiert)
Get-Cluster -Name myCluster
Get-ClusterNode  -Cluster myCluster | Format-Table Name, State, NodeWeight, DynamicWeight
Get-ClusterQuorum -Cluster myCluster
(Get-Cluster myCluster).WitnessDynamicWeight
Get-ClusterResource -Cluster myCluster | Format-Table Name, ResourceType, OwnerGroup, State
Get-ClusterNetwork  -Cluster myCluster | Format-Table Name, Role, Address   # Role: 0 keine, 1 nur Cluster, 3 Cluster+Client
```

## Quellen
- [Configure and manage quorum – Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/failover-clustering/manage-cluster-quorum)
- [Set-ClusterQuorum – Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/failoverclusters/set-clusterquorum)
- [What's new in Windows Server 2025 – Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/get-started/whats-new-windows-server-2025)
- [S2D Campus Cluster on Windows Server 2025 – Tech Community](https://techcommunity.microsoft.com/blog/failoverclustering/-/4477075)
