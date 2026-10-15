---
aliases: []
tags: [glossar, glossar/windows-server]
en: Quorum
de: Beschlussfähigkeit
bereich: windows-server
---
---
aliases: [Clusterquorum, Quorum-Konfiguration, Stimmenmehrheit]
tags: [glossar, glossar/windows-server]
en: Quorum
de: Beschlussfähigkeit
bereich: windows-server
---

# Quorum

Ein [[Failover-Cluster]] läuft nur weiter, wenn **mehr als die Hälfte aller Stimmen** online ist. Jeder Knoten hat 1 Stimme, ein Zeuge ([[Witness]]) ggf. 1 weitere. Zweck: verhindert [[Split-Brain]], also zwei Clusterhälften, die gleichzeitig dieselben Daten schreiben.

Die Abstimmung ist kein Wahlgang mit Stimmzetteln. Jeder Knoten **zählt**, wie viele Stimmen er gerade erreichen kann. Nur die Seite mit der Mehrheit darf weiterarbeiten.
### So läuft es ab

1. **Lebenszeichen:** Die Knoten senden sich laufend [[Heartbeat]]s, etwa jede Sekunde.
2. **Störung:** Bleiben die Heartbeats aus, weiß ein Knoten nicht, ob der andere ausgefallen ist oder nur das Netz dazwischen.
3. **Zählen:** Jede Gruppe von Knoten, die sich noch erreichen, zählt ihre Stimmen. Erreichbare Knoten zählen je 1, der Zeuge zählt 1, wenn die Gruppe ihn erreicht.
4. **Entscheiden:**
    - Gruppe **mit Mehrheit**: Der Cluster läuft weiter, und sie übernimmt die Rollen (Failover).
    - Gruppe **ohne Mehrheit**: Sie stoppt ihren Clusterdienst freiwillig und gibt Datenträger und IP-Adressen frei.

### Wofür der Zeuge

Er ist der **Schiedsrichter** bei Gleichstand. Beispiel mit 2 Knoten und Datenträgerzeuge, die Netzverbindung zwischen den Knoten reißt ab:

**Formel:** benötigt = (Stimmen ÷ 2, abgerundet) + 1

| Aufbau | Stimmen | benötigt | darf ausfallen |
|---|---|---|---|
| 2 Knoten | 2 | 2 | 0 ❌ |
| 2 Knoten + Zeuge | 3 | 2 | 1 |
| 3 Knoten | 3 | 2 | 1 |
| 4 Knoten + Zeuge | 5 | 3 | 2 |
| 5 Knoten | 5 | 3 | 2 |

> [!tip] Merksatz
> Gesamtzahl der Stimmen immer **ungerade** halten → gerade Knotenzahl + Zeuge.

## Quorum-Modi
| Modus (GUI) | Stimmen | Befehl |
|---|---|---|
| Knotenmehrheit | nur Knoten | `Set-ClusterQuorum -NoWitness` |
| Knoten- und Datenträgermehrheit | Knoten + Datenträgerzeuge | `Set-ClusterQuorum -DiskWitness "Cluster Disk 1"` |
| Knoten- und Dateifreigabemehrheit | Knoten + Freigabezeuge | `Set-ClusterQuorum -FileShareWitness \\EXA-DC01\Witness` |
| Cloudzeuge | Knoten + Azure-Blob | `Set-ClusterQuorum -CloudWitness -AccountName … -AccessKey …` |
| Nur Datenträger | nur der Datenträger | ⚠ nicht empfohlen (Single Point of Failure) |

## Zeugentypen
- **Datenträgerzeuge:** > 512 MB, Basisdatenträger, NTFS/ReFS, kein Laufwerksbuchstabe.
- **Dateifreigabezeuge:** SMB-Freigabe außerhalb des Clusters, ≥ 5 MB frei, nicht auf DFS. Ab Server 2019 auch auf NAS oder Router mit USB.
- **Cloudzeuge:** Azure-Speicherkonto, ausgehend HTTPS 443.

## Dynamisch
- [[Dynamisches Quorum]]: Fällt ein Knoten geordnet aus, verliert er seine Stimme. Dadurch übersteht der Cluster Ausfälle nacheinander („Last Man Standing“).
- **Dynamischer Zeuge:** Bei ungerader Knotenzahl stimmt der Zeuge nicht mit, bei gerader schon.
- Microsoft empfiehlt ab Server 2012 R2 **immer** einen Zeugen zu konfigurieren.

## Prüfen
```powershell
# Maschine: EXA-DC01 (RSAT-Clustering)
Get-ClusterQuorum -Cluster myCluster
Get-ClusterNode -Cluster myCluster | Format-Table Name, State, NodeWeight, DynamicWeight
(Get-Cluster myCluster).WitnessDynamicWeight   # 0 = Zeuge stimmt gerade nicht mit
```

**Siehe auch:** [[Witness]] · [[Dynamisches Quorum]] · [[Split-Brain]] · [[Failover-Cluster]]
**Thema:** [[Cluster und Failover]] · Mehr: [[Failovercluster#2. Quorum und Zeugen|Quorum und Zeugen]] · Übung: [[Uebung_Failovercluster_Loesung.pdf#page=4|Schritt 6]] · [[Uebung_Failovercluster_Loesung.pdf#page=5|Schritt 7]] · Fragen: [[Failovercluster_12_Fragen.pdf#page=1|A4]] · [[Failovercluster_12_Fragen.pdf#page=3|A9]]