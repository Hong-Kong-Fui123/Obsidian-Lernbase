---
aliases:
  - SMB Direct
  - SMB über RDMA
  - SMB-Direct
tags:
  - glossar
  - glossar/netzwerk
en: SMB Direct
de: SMB über RDMA
bereich: Netzwerk
---

**SMB Direct** = *SMB Direct*
**Deutsch:** SMB über RDMA

## Kurz
SMB 3 über [[RDMA]]-Netzwerkkarten. Wird automatisch genutzt, wenn beide Seiten RDMA können.

## Details
- Livemigration mit Leistungsoption **SMB** nutzt SMB Direct
- Auch für Hyper-V über SMB, [[SoFS]], Storage Spaces Direct
- Port TCP 5445 (iWARP)

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Set-VMHost -VirtualMachineMigrationPerformanceOption SMB
Get-SmbClientNetworkInterface | Format-Table FriendlyName, RdmaCapable
```

## Prüfungsfrage
Welche Leistungsoption der Livemigration nutzt SMB Direct?

> [!success]- Lösung
> Die Option **SMB** (bei RDMA-fähigen Karten).

## Siehe auch
[[SMB]] · [[RDMA]] · [[SMB Multichannel]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]

**AZ-802:** [[AZ-802 5 Speicher und Dateidienste]] · [[AZ-802 Übersicht]]
