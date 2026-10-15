---
typ: uebersicht
tags: [moc, log]
---
# Änderungen 2026-10-15 (Failovercluster)

Zurück: [[Start]] · Vorher: [[Änderungen 2026-10-07]]

## PDFs (`99_Anhänge/PDF/Failovercluster/`)
| Datei | Inhalt |
|---|---|
| [[Failovercluster_12_Fragen.pdf]] | Original: Wissensfragen A1–A12 |
| [[Failovercluster_12_Fragen_Loesung.pdf]] | Original-Lösungen (S. 1–3) + **S. 4 Ergänzungen und Quellen** (mit Microsoft Learn geprüft) |
| [[Uebung_Failovercluster.pdf]] | Original: Übung Schritte 1–11 |
| [[Uebung_Failovercluster_Loesung.pdf]] | **Neu:** Übung mit Lösung je Schritt (GUI + PowerShell, Maschine, Prüfung) + Korrekturen der Vorlage |

## Neue Notizen
- Wissen: [[Failovercluster]] · [[Hochverfügbarer Dateiserver]]
- Lab: [[Lab Failovercluster Dateiserver]] (Ablauftabelle mit Seitenlinks, Validierung, typische Fehler)
- Glossar (14): [[ABE]] · [[Bevorzugter Besitzer]] · [[CAU]] · [[Clientzugriffspunkt]] · [[CNO]] · [[Dynamisches Quorum]] · [[Failback]] · [[Fortlaufende Verfügbarkeit]] · [[iSCSI-Initiator]] · [[iSCSI-Target]] · [[MPIO]] · [[SMB-Zeuge]] · [[SoFS]] · [[VCO]]

## Ergänzt / verlinkt
- [[Cluster und Failover]]: Abschnitt „Vertiefung Schule“, Glossarzeile, 3 kaputte Links repariert (Active Directory, Hyper-V, Storage Spaces Direct)
- [[Windows Server]]: Abschnitt „Hochverfügbarkeit / Cluster“
- [[Start]] · [[50_Wissen]] · [[PDF-Index]] · [[00_Glossar-Index]] · [[VM-Infrastruktur]] (IP-Hinweis) · [[00 Uebersicht Theorieklausuren]]
- Glossar: [[Failover-Cluster]] · [[Quorum]] · [[Witness]] · [[CSV]] · [[Split-Brain]] · [[Cluster-IP]] · [[iSCSI]] · [[SMB]]

## Fachliche Hinweise
- Vorlage Übung: *SYD-DC* → EXA-DC01 · *PC1, PC2* → EXA-SRV01/02/04 · Reiter „Failback“ heißt **Failover**
- Lösung A11: „Verbesserungen bei CAU“ nicht in Microsofts Liste für Server 2025; Campus-Cluster erst mit Update 2025-12
- Home-Lab: 192.168.1.100/.101 sind belegt → .230/.231
