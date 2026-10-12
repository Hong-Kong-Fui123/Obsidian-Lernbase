---
aliases:
  - VMRS
  - vmrs
  - Saved State
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Machine Runtime State
de: VM-Laufzeitstatus
bereich: Virtualisierung
---

**VMRS** = *Virtual Machine Runtime State*
**Deutsch:** VM-Laufzeitstatus

## Kurz
Laufzeitstatus-Datei einer VM: enthält RAM-Inhalt und Zustand bei *Saved State*.

## Details
- CPU-abhängig → Start auf anderem Host kann scheitern
- Vor Export VM herunterfahren oder Saved State löschen

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Remove-VMSavedState -VMName EXA-SRV02
```

## Prüfungsfrage
Warum kann ein Saved State auf einem anderen Host Probleme machen?

> [!success]- Lösung
> Er ist an Prozessor-Eigenschaften des Quellhosts gebunden.

## Siehe auch
[[VMCX]] · [[VMGS]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
