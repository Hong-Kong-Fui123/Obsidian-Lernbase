---
aliases:
  - AVHDX
  - avhdx
tags:
  - glossar
  - glossar/virtualisierung
en: Automatic Virtual Hard Disk
de: Differenzdatenträger
bereich: Virtualisierung
---

**AVHDX** = *Automatic Virtual Hard Disk*
**Deutsch:** Differenzdatenträger

## Kurz
Differenzdatenträger, der beim Erstellen eines [[Checkpoint|Checkpoints]] entsteht und nur Änderungen speichert.

## Details
- Bildet eine Kette zur Eltern-VHDX
- Beim Löschen eines Checkpoints werden die Daten zusammengeführt (Merge)
- Lange Ketten bremsen die VM

## Prüfungsfrage
Warum soll man AVHDX-Dateien nie von Hand löschen?

> [!success]- Lösung
> Die Kette bricht, die VM verliert Daten oder startet nicht mehr.

## Siehe auch
[[Checkpoint]] · [[VHDX]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
