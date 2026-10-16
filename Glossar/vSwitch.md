---
aliases:
  - vSwitch
  - Virtueller Switch
  - Hyper-V Switch
tags:
  - glossar
  - glossar/virtualisierung
en: Virtual Switch
de: Virtueller Switch
bereich: Virtualisierung
---

**vSwitch** = *Virtual Switch*
**Deutsch:** Virtueller Switch

## Kurz
Virtueller Switch in Hyper-V, der VMs untereinander und mit dem Netzwerk verbindet.

## Details
- External: mit physischer Netzwerkkarte · Internal: VMs + Host · Private: nur VMs
- Fehlt beim Import der gleiche Name → Inkompatibilität 33012
- [[Livemigration]]: gleicher vSwitch-Name auf beiden Hosts, sonst fragt der Assistent nach

## Beispiel
Maschine: **Hyper-V-Host**
```powershell
Get-VMSwitch | Select Name, SwitchType
New-VMSwitch -Name 'LabSwitch' -SwitchType Internal
```

## Prüfungsfrage
Welcher Switch-Typ verbindet VMs untereinander, aber nicht mit dem Host?

> [!success]- Lösung
> Private.

## Siehe auch
[[Compare-VM]] · [[VM-Import]] · [[HyperV-VM-Export-Import]] · [[Livemigration]] · [[00_Glossar-Index]]
