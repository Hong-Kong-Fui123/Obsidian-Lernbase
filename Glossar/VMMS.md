---
aliases:
  - VMMS
  - Virtual Machine Management Service
  - vmms
  - Hyper-V-VM-Verwaltung
  - Microsoft Virtual System Migration Service
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Machine Management Service
de: Hyper-V-Verwaltungsdienst für virtuelle Computer
bereich: Virtualisierung
---

**VMMS** = *Virtual Machine Management Service*
**Deutsch:** Hyper-V-Verwaltungsdienst für virtuelle Computer

## Kurz
Zentraler Hyper-V-Dienst (`vmms.exe`) auf jedem Host: verwaltet VMs und führt Migrationen aus.

## Details
- Dienstname in der Delegierung: **Microsoft Virtual System Migration Service**
- Neustart: `Restart-Service vmms` (laufende VMs bleiben an)
- Ereignisse: *Microsoft-Windows-Hyper-V-VMMS-Admin*

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-Service vmms
Get-WinEvent -LogName 'Microsoft-Windows-Hyper-V-VMMS-Admin' -MaxEvents 20
```

## Prüfungsfrage
Welcher Delegierungsdienst gehört zur VMMS?

> [!success]- Lösung
> Microsoft Virtual System Migration Service.

## Siehe auch
[[Eingeschränkte Delegierung]] · [[Hyper-V]] · [[Hyper-V Livemigration]] · [[00_Glossar-Index]]
