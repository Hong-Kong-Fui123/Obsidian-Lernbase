---
aliases:
  - Kubernetes
  - K8s
tags:
  - glossar
  - glossar/virtualisierung
en: Kubernetes
de: Kubernetes (Container-Orchestrierung)
bereich: Virtualisierung
---

**Kubernetes** = *Kubernetes*
**Deutsch:** Kubernetes (Container-Orchestrierung)

## Kurz
Open-Source-Plattform zur [[Orchestrierung]] von Containern, ursprünglich von Google.

## Details
- Begriffe: Cluster, Node, Pod, Deployment, Service, Namespace
- Steuerung mit `kubectl`, Konfiguration als YAML
- Azure: AKS; lokal testbar in [[Docker-Desktop]]

## Beispiel
Maschine: **Windows-11-PC**
```powershell
kubectl get nodes
kubectl get pods -A
```

## Prüfungsfrage
Was ist ein Pod?

> [!success]- Lösung
> Kleinste Einheit in Kubernetes: ein oder mehrere Container mit gemeinsamem Netzwerk und Speicher.

## Siehe auch
[[Orchestrierung]] · [[Containerd]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
