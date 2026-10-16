---
typ: uebersicht
tags: [moc, log]
---
# Änderungen 2026-10-16 (Livemigration)

Zurück: [[Start]] · Vorher: [[Änderungen 2026-10-15]]

## Neu
- Wissen: [[Hyper-V Livemigration]] – Arten, Ablauf, Voraussetzungen, CredSSP vs. Kerberos, Delegierung, Leistungsoptionen, Netzwerk, Befehle, Fehler, Server 2025, Prüfungsfragen; Buchlinks 70-740 S. 358–366 und 434–436
- Glossar (14): [[Livemigration]] · [[Shared-Nothing-Livemigration]] · [[Speichermigration]] · [[Schnellmigration]] · [[CredSSP]] · [[Eingeschränkte Delegierung]] · [[Credential Guard]] · [[Migrationsnetzwerk]] · [[RDMA]] · [[SMB Direct]] · [[SMB Multichannel]] · [[Prozessorkompatibilität]] · [[VMMS]] · [[Hyper-V]]

## Ergänzt
- Glossar: [[Kerberos]] · [[vSwitch]] · [[Konfigurationsversion]] · [[Compare-VM]] · [[Hypervisor]] · [[CSV]] · [[SMB]] · [[SoFS]] · [[CAU]] · [[Failover-Cluster]] · [[00_Glossar-Index]]
- Notizen: [[Failovercluster]] · [[HyperV-VM-Export-Import]] · [[Cluster und Failover]] · [[Windows Server]] · [[50_Wissen]] · [[VM-Infrastruktur]] · [[Start]]

## Fachlicher Hinweis
- Buch 70-740 nennt CredSSP als Standard. Ab Server 2025 ist Credential Guard aktiv → CredSSP-Livemigration scheitert → Kerberos + eingeschränkte Delegierung.
