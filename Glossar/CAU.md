---
aliases: [Cluster-Aware Updating, Clusterfähiges Aktualisieren]
tags: [glossar, glossar/windows-server]
en: Cluster-Aware Updating
de: Clusterfähiges Aktualisieren
bereich: windows-server
---

# CAU

Patcht Clusterknoten nacheinander: Rollen verschieben → Updates → Neustart → Knoten wieder aufnehmen. Modi: **Selbstaktualisierung** (CAU-Rolle im Cluster, `Add-CauClusterRole`) und **Remoteaktualisierung** (Verwaltungs-PC, `Invoke-CauRun`).

**Siehe auch:** [[WSUS]] · [[Failover-Cluster]] · [[Livemigration]] (verschiebt VMs vor dem Patchen)
**Thema:** [[Cluster und Failover]] · Mehr: [[Failovercluster#5. Cluster-Aware Updating (CAU)|CAU]]
