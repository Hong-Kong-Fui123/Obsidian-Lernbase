---
aliases:
  - VMGS
  - vmgs
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Machine Guest State
de: VM-Gastzustand
bereich: Virtualisierung
---

**VMGS** = *Virtual Machine Guest State*
**Deutsch:** VM-Gastzustand

## Kurz
Gastzustandsdatei einer Generation-2-VM, enthält u. a. Daten des [[vTPM]].

## Details
- Wird beim Export mitkopiert
- Ohne passende Guardian-Zertifikate startet eine vTPM-VM auf neuem Host nicht

## Prüfungsfrage
Was muss bei einer VM mit vTPM zusätzlich zum Export mitgenommen werden?

> [!success]- Lösung
> Die Guardian-Zertifikate („Shielded VM Local Certificates“) des Quellhosts.

## Siehe auch
[[vTPM]] · [[VMCX]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
