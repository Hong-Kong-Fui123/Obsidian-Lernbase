---
aliases:
  - Orchestrierung
  - Container-Orchestrierung
tags:
  - glossar
  - glossar/virtualisierung
en: Container Orchestration
de: Container-Orchestrierung
bereich: Virtualisierung
---

**Orchestrierung** = *Container Orchestration*
**Deutsch:** Container-Orchestrierung

## Kurz
Automatische Verwaltung vieler Container über mehrere Hosts hinweg.

## Details
- Aufgaben: Verteilen, Skalieren, Selbstheilung, Rolling Updates, Lastverteilung
- Werkzeuge: [[Kubernetes]], Docker Swarm, Azure Kubernetes Service (AKS)
- Compose = ein Host, Orchestrierung = Cluster

## Prüfungsfrage
Wann reicht Compose nicht mehr aus?

> [!success]- Lösung
> Wenn Container über mehrere Hosts verteilt, automatisch skaliert und ausfallsicher betrieben werden müssen.

## Siehe auch
[[Kubernetes]] · [[Docker-Compose]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
