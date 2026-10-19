---
aliases:
  - Hyper-V
  - HyperV
  - Hyper V
  - Microsoft Hyper-V
tags:
  - glossar
  - glossar/virtualisierung
en: Hyper-V
de: Hyper-V (Microsoft-Hypervisor)
bereich: Virtualisierung
---

**Hyper-V** = *Hyper-V*
**Deutsch:** Hyper-V (Microsoft-Hypervisor)

## Kurz
Typ-1-[[Hypervisor]] von Microsoft, als Rolle in Windows Server bzw. Feature in Windows 10/11 Pro.

## Details
- Bausteine: [[vSwitch]], [[VHDX]], [[Checkpoint]], Integrationsdienste
- Hochverfügbarkeit: [[Failover-Cluster]], [[Livemigration]], Hyper-V-Replikat
- Verwaltung: Hyper-V-Manager, PowerShell-Modul *Hyper-V*, Windows Admin Center

## Beispiel
Maschine: **Server (Host)**
```powershell
Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart
Get-VM
```

## Prüfungsfrage
Hyper-V ist Typ 1 oder Typ 2?

> [!success]- Lösung
> Typ 1 – der Hypervisor läuft direkt auf der Hardware, Windows wird zur Parent-Partition.

## Siehe auch
[[Hypervisor]] · [[vSwitch]] · [[HyperV-VM-Export-Import]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]

**AZ-802:** [[AZ-802 3 Virtuelle Maschinen]] · [[AZ-802 Übersicht]]
