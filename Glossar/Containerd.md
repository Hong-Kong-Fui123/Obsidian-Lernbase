---
aliases:
  - Containerd
  - containerd
tags:
  - glossar
  - glossar/virtualisierung
en: containerd
de: Container-Laufzeit
bereich: Virtualisierung
---

**Containerd** = *containerd*
**Deutsch:** Container-Laufzeit

## Kurz
Container-Laufzeit unterhalb des Docker-Daemons. Startet Container über `runc` nach [[OCI]]-Standard.

## Details
- Auch ohne Docker nutzbar, z. B. direkt in [[Kubernetes]]
- Verwaltet Images und Container-Lebenszyklus auf niedriger Ebene

## Prüfungsfrage
Welche Rolle spielt containerd gegenüber dockerd?

> [!success]- Lösung
> dockerd nimmt Befehle an und verwaltet, containerd führt die Container tatsächlich aus.

## Siehe auch
[[OCI]] · [[Docker-Engine]] · [[Kubernetes]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
