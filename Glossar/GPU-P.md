---
aliases: [GPU-Partitionierung, GPU Partitioning]
tags: [glossar, glossar/virtualisierung, az-802]
en: "GPU Partitioning"
de: "GPU-Partitionierung"
bereich: Virtualisierung
---

# GPU-P

Teilt **eine** physische GPU in Partitionen für mehrere VMs.

- Server 2025: GPU-P-VMs live migrierbar und im Cluster hochverfügbar
- Unterschied zu [[DDA]]: geteilt statt exklusiv

Maschine: **Hyper-V-Host**
```powershell
Add-VMGpuPartitionAdapter -VMName EXA-WEB01
Get-VMGpuPartitionAdapter -VMName EXA-WEB01
```

**Siehe auch:** [[DDA]] · [[Hyper-V Livemigration]]
**Thema:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
