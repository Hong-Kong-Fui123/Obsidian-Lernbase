---
aliases: [Hyper-V Replica, Replikat, Replikatbroker]
tags: [glossar, glossar/virtualisierung, az-802]
en: "Hyper-V Replica"
de: "Hyper-V-Replikat"
bereich: Virtualisierung
---

# Hyper-V-Replikat

Asynchrone Kopie einer VM auf einen zweiten Host – für **Notfallwiederherstellung**, nicht Hochverfügbarkeit.

- Intervall 30 s, 5 Min. oder 15 Min.; Kerberos (HTTP 80) oder Zertifikat (HTTPS 443)
- Testfailover · geplantes · ungeplantes Failover; im Cluster: Replikatbroker

Maschine: **EXA-HV01**
```powershell
Enable-VMReplication -VMName EXA-WEB01 -ReplicaServerName EXA-HV02 -ReplicaServerPort 80 -AuthenticationType Kerberos
Start-VMInitialReplication -VMName EXA-WEB01
```

**Siehe auch:** [[Hyper-V Livemigration]] · [[Failovercluster]] · [[RPO]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
